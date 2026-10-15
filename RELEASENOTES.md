### 0.1.1







* tests now use the default allocator instead of the test allocator
* infinite concurrency loops only run when FOREVER is defined

## 0.1.0




feature: document and specify the concurrent list memory model, add public wrappers

* new public ``mulle_concurrent_linkedlist_remove_one`` and ``mulle_concurrent_linkedlist_walk`` wrappers that accept a NULL list
* memory model of the concurrent list is now specified in ``dox/MEMORY_MODEL.md`` and annotated at each call site
* speculative head reads in ``add`/`remove_all`` now use relaxed atomics; all publishing/consuming head CAS operations stay sequentially consistent
* new ``MULLE_LINKEDLIST_NO_CONCURRENT`` include guard to build without the concurrent API
* requires mulle-thread 4.9.0 or better for the ``_relaxed`` atomic API
* list is now correctly documented as lock-free instead of wait-free
* new `ll-publish` test pins publication ordering of non-atomic payloads and is tsan clean



* add Documentation & Guides section to README with API summary link
* relocate API table of contents to asset/dox/api/toc/
