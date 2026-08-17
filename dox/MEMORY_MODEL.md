# mulle-linkedlist memory model

This document is the authoritative statement of the concurrency contract of
`struct _mulle_concurrent_linkedlist`. It exists because `mulle-thread`
distinguishes default (sequentially consistent) and `_relaxed` atomic
operations, and this list deliberately uses both.

The single-threaded `struct _mulle_linkedlist` has no memory model. It uses
plain loads and stores and requires external synchronization for any sharing.

**Requires mulle-thread 4.9.0 or better.** The `_relaxed` suffixed API does not
exist in earlier versions.


## What mulle-thread provides

`mulle-thread` exposes exactly two orderings for `mulle_atomic_pointer_t`:

| Form                                    | C11 mapping             |
|-----------------------------------------|-------------------------|
| `_mulle_atomic_pointer_read`, `_cas`, `_weakcas`, ...    | `memory_order_seq_cst` |
| `_mulle_atomic_pointer_read_relaxed`, `_cas_relaxed`, ... | `memory_order_relaxed` |
| `_mulle_atomic_pointer_nonatomic_read`, `_write_nonatomic` | plain load/store, no atomicity, no ordering |

There is **no** acquire-only or release-only variant. Consequently every
operation in this list that publishes or consumes an entry must use the default
seq_cst form. Relaxed is only usable where no ordering is required at all.

The policy of this project is: *relaxed where provably sufficient, default
everywhere else.*


## The load-bearing invariant

> Every store to `_head` after initialization is a read-modify-write.

`add`, `remove_all` and `remove_one` all mutate `_head` with a CAS. There is no
plain `_write` on `_head` anywhere. Because of this, the modification order of
`_head` is one unbroken chain of read-modify-write operations, which in C11
terms is a single *release sequence*. A thread that seq_cst-reads any value of
`_head` therefore synchronizes not only with the publisher of that value, but
transitively with every publication that precedes it in the modification order.

This is what makes the relaxed reads below sound rather than merely
"works on x86". It relies only on the read-modify-write clause of the release
sequence definition (C11 5.1.2.4), which is unchanged in the later C++ memory
model, so the argument is portable.

**If you ever add a `_mulle_atomic_pointer_write` or `_write_relaxed` on
`_head`, this reasoning collapses and the relaxed reads become unsound.**


## Per-operation ordering

| Operation      | `_head` access                      | Ordering used | Why |
|----------------|-------------------------------------|---------------|-----|
| `init`         | `memset`                            | none          | list not yet reachable by other threads |
| `done`         | nonatomic read (assert only)        | none          | all other threads must have quiesced |
| `add`          | relaxed read + **seq_cst CAS**      | mixed         | see below |
| `remove_all`   | relaxed read + **seq_cst CAS**      | mixed         | see below |
| `remove_one`   | `remove_all` + **seq_cst CAS**      | mixed         | see below |
| `walk`         | nonatomic read, plain `_next` loads | none          | not thread safe at all, by design |

### `add` — publication

```c
do
{
   head = _mulle_atomic_pointer_read_relaxed( &list->_head.pointer);
   entry->_next = head;
}
while( ! _mulle_atomic_pointer_cas( &list->_head.pointer, entry, head));
```

The read is relaxed because `head` is never dereferenced by this thread. It is
only stored into `entry->_next` and used as the CAS `expect` operand. A stale
value simply makes the CAS fail, and the loop retries.

The CAS is seq_cst and is the release that publishes the entry. It orders both
the `entry->_next` store and the caller's initialization of the surrounding
object before the entry becomes reachable from `_head`.

Caller obligations:

- complete all writes to the entry **before** calling `add`
- do not touch the entry **after** calling `add`
- the entry must be unlinked (`_next == NULL`) and exclusively owned

### `remove_all` — consumption

```c
do
{
   head = _mulle_atomic_pointer_read_relaxed( &list->_head.pointer);
   if( ! head)
      break;
}
while( ! _mulle_atomic_pointer_weakcas( &list->_head.pointer, NULL, head));
return( head);
```

The caller *does* dereference the returned chain, but the acquire it needs does
not come from the read. It comes from the successful seq_cst CAS, which is a
read-modify-write that reads the very value being returned. The relaxed read
only proposes a candidate.

On the `head == NULL` path nothing is dereferenced, so no ordering is needed.

A NULL return means "the list was observed empty at some point during the
call", never "the list is empty now". That is inherent to a lock-free list and
is not a consequence of the relaxed read: a seq_cst read would be equally
stale by the time the caller inspects the result.

### `remove_one` — detach, mutate privately, republish

After `remove_all` succeeds, the detached chain is **private** to the calling
thread. Nobody else can reach it, because it is no longer referenced from
`_head`. The traversal to the tail and the `tail->_next = prev_chain` fixup
therefore use plain, non-atomic accesses on purpose. Making them atomic would
be pure cost with no benefit.

The final seq_cst CAS republishes the retained chain and is the release for
those fixups. After it succeeds the thread must not touch the chain again.

No explicit `mulle_atomic_memory_barrier()` is required anywhere in this
function. An earlier version of the source carried a commented-out barrier at
the end; it was redundant and has been removed, because the seq_cst CAS already
orders everything sequenced before it, and the returned entry is republished
(if at all) through another seq_cst CAS.

Note that this operation is **O(n)** in the length of the retained chain, and
the retry loop is unbounded.

### `walk`

Not thread safe at all. `_head` is read non-atomically and `_next` is followed
with plain loads. Valid only when the caller has exclusive access.


## Progress guarantees

The concurrent list is **lock-free**, not wait-free. `add`, `remove_all` and
`remove_one` are CAS retry loops with no bound on the number of retries. An
individual thread can be delayed indefinitely under contention. Any
documentation claiming wait-freedom is wrong.


## What this list does not do

Ordering is not reclamation. The memory model above guarantees that a thread
which obtains an entry sees fully initialized contents. It says **nothing**
about when that entry may be freed or reused.

`remove_one` and `remove_all` hand out pointers that another thread may already
have loaded. Freeing or reusing such an entry immediately is a use-after-free
and can reintroduce ABA. This list provides no hazard pointers, no epochs, no
reference counts and no grace-period API. The caller must supply the
discipline, for example:

- all removal and reclamation happens after an externally established
  quiescent point (this is what the bundled test does: it retains everything
  until the worker threads have joined)
- entries are never freed, only recycled through the same list, and their
  storage outlives all participating threads
- an external scheme such as `mulle-aba` owns the reclamation

Pick one and state it at the call site.


## How to verify this

`test/10-linkedlist/ll-publish.c` is the regression test for the contract above.
Each entry carries a non-atomic payload written before `add` and verified after
removal, so nothing but the list's publication ordering makes it well defined.

Two caveats when running it:

1. **On x86/x64 a plain run proves almost nothing.** The hardware is strongly
   ordered, so even a deliberately relaxed publication CAS passes. The test only
   becomes a memory-model check under ThreadSanitizer, or on a weakly ordered
   CPU (ARM64, PPC).
2. **ThreadSanitizer needs the pthreads backend.** mulle-thread prefers the C11
   `<threads.h>` backend when available, and `thrd_create` is not intercepted by
   tsan, so instrumented threads start without tsan thread state and crash on
   entry. Build with `-DMULLE_THREAD_USE_PTHREADS` for sanitizer runs.

A useful control experiment: change the publishing CAS in `add` to
`_mulle_atomic_pointer_cas_relaxed` and re-run under tsan. It must report races
on the payload and on `_next`. If it does not, the test is not exercising the
publication path.


## Backend note

The specification above is written against the C11 `stdatomic` backend
(`mulle-atomic-c11.h`), which is what is used whenever `<stdatomic.h>` is
available. The mintomic fallback backend implements the default CAS without an
explicit fence, relying on the platform CAS being a full barrier. That holds on
x86/x64; for weakly ordered targets the mintomic path should be audited before
it is relied upon.


## Rules for future changes

1. Never store to `_head` with anything but a read-modify-write.
2. A relaxed read of `_head` is only acceptable if its value is not
   dereferenced and is used solely as a CAS `expect` operand.
3. Anything that publishes an entry, or that hands a chain to a caller for
   dereferencing, uses the default seq_cst operation.
4. Accesses to a chain that the current thread has already detached stay
   non-atomic.
5. If mulle-thread ever grows acquire/release variants, the CASes here can be
   narrowed to release (publication) and acquire (consumption); update this
   document in the same commit.
