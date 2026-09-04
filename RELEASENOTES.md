### 0.1.0

* the memory model of `struct _mulle_concurrent_linkedlist` is now specified in
  `dox/MEMORY_MODEL.md` and annotated at each call site
* **requires mulle-thread 4.9.0 or better**, whose default atomic operations are
  sequentially consistent and which supplies the `_relaxed` API
* `_mulle_concurrent_linkedlist_add` and `_mulle_concurrent_linkedlist_remove_all`
  now use `_mulle_atomic_pointer_read_relaxed` for the speculative head read at
  the top of their CAS retry loop. The value is never dereferenced and serves
  only as the CAS `expect` operand, so no ordering is required there. All CAS
  operations on the head remain sequentially consistent, as publication and
  consumption depend on them
* removed the redundant commented-out `mulle_atomic_memory_barrier()` from
  `_mulle_concurrent_linkedlist_remove_one`
* the list is documented as lock-free. It was previously described as wait-free,
  which was incorrect: all mutating operations are unbounded CAS retry loops
* new test `ll-publish` pins the publication ordering. It verifies a non-atomic
  payload across `add`/`remove_one`/`remove_all` and is tsan clean

### 0.0.8

Various small improvements
