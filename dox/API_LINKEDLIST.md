# mulle-linkedlist API

This project provides two intrusive linked lists:

- `struct _mulle_linkedlist`: single-threaded LIFO list.
- `struct _mulle_concurrent_linkedlist`: CAS-based concurrent LIFO list.

Entries are embedded in caller-owned objects. An entry must be unlinked and
owned exclusively by the caller before it is added to a list.

## Single-threaded list

```c
struct _mulle_linkedlistentry
{
   struct _mulle_linkedlistentry   *_next;
};

struct _mulle_linkedlist
{
   struct _mulle_linkedlistentry   _head;
};
```

The basic entry helpers are:

- `_mulle_linkedlistentry_chain(head, entry)` — prepend an entry, O(1).
- `_mulle_linkedlistentry_unchain(head)` — remove the first entry, O(1).
- `mulle_linkedlistentry_walk(next, callback, userinfo)` — walk a detached
  chain.

List operations include `_mulle_linkedlist_init`, `_mulle_linkedlist_done`,
`_mulle_linkedlist_add`, `_mulle_linkedlist_remove_one`,
`_mulle_linkedlist_remove_all`, and `mulle_linkedlist_walk`.

The single-threaded list must not be accessed concurrently without external
synchronization.

## Concurrent list

```c
struct _mulle_concurrent_linkedlistentry
{
   struct _mulle_concurrent_linkedlistentry   *_next;
};
```

The list type contains an opaque mulle-thread atomic head pointer; initialize it
with `_mulle_concurrent_linkedlist_init` rather than constructing its internals.

Operations are:

- `_mulle_concurrent_linkedlist_init` / `_done`.
- `_mulle_concurrent_linkedlist_add` — CAS-based prepend, with retry.
- `_mulle_concurrent_linkedlist_remove_all` — atomically detach the whole
  chain, with retry.
- `_mulle_concurrent_linkedlist_remove_one` — remove one entry by detaching
  and rebuilding the remaining chain; worst-case O(n), with retry.
- `_mulle_concurrent_linkedlist_walk` — **not thread-safe**.

The concurrent operations do not provide memory reclamation. Removing an entry does not make it safe to free or reuse while another thread may still hold a
pointer to it. Callers must provide the required quiescence, ownership, or
reclamation discipline for their workload.

The list is **lock-free**, not wait-free: all three mutating operations are
unbounded CAS retry loops.

The atomic ordering used by each operation, and the publication and
consumption obligations of the caller, are specified in
[MEMORY_MODEL.md](MEMORY_MODEL.md). Read it before using the concurrent list.

The list prepends entries; it does not append them. The API is intentionally
minimal and does not allocate or free entries.

See the source headers for precondition annotations and complete signatures.
