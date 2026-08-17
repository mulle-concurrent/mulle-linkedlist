# mulle-linkedlist

#### 🔂 mulle-linkedlist a lock-free intrusive linked list

The mulle-concurrent-linkedlist is a barebones lock-free intrusive linked list
used by mulle-aba and the mulle-objc-runtime. A single-threaded variant is also
supplied. It is normally consumed as part of mulle-core via CMake.



| Release Version                                       | Release Notes  | AI Documentation
|-------------------------------------------------------|----------------|---------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-concurrent/mulle-linkedlist.svg) [![Build Status](https://github.com/mulle-concurrent/mulle-linkedlist/workflows/CI/badge.svg)](//github.com/mulle-concurrent/mulle-linkedlist/actions) | [RELEASENOTES](RELEASENOTES.md) | [DeepWiki for mulle-linkedlist](https://deepwiki.com/mulle-concurrent/mulle-linkedlist)


## API

| Data Structure                                         | Description
| -------------------------------------------------------|----------------------------
| [`mulle-concurrent-linkedlist`](dox/API_LINKEDLIST.md) | A lock-free intrusive linked list

The concurrency contract of the concurrent list, which atomic ordering each
operation uses and what the caller must guarantee, is specified in
[MEMORY_MODEL.md](dox/MEMORY_MODEL.md).





## Documentation & Guides

* [API Summary](asset/dox/api/toc)




### You are here

![Overview](overview.dot.svg)





## Add

mulle-linkedlist is a component of the [mulle-core](//github.com/mulle-core/mulle-core) library. So in your code include the mulle-core umbrella header:

``` c
#include <mulle-core/mulle-core.h>
```

### Add mulle-core to a cmake and git project

``` bash
git submodule add https://github.com/mulle-core/mulle-core.git mulle-core
```

Add this to your `CMakeLists.txt`:

``` cmake
add_subdirectory( mulle-core)
target_link_libraries( ${PROJECT_NAME} PRIVATE mulle-core)
```


### Add mulle-core to a mulle-sde project

``` sh
mulle-sde add github:mulle-core/mulle-core
```

### Embed mulle-linkedlist with clib

``` sh
clib install --out src mulle-concurrent/mulle-linkedlist
```

Append `src` to your include path (e.g. add `-isystem src`  to your `CFLAGS`)
and compile all the sources that were downloaded.

## Install

Use [mulle-sde](//github.com/mulle-sde) to build and install mulle-linkedlist and all dependencies:

``` sh
mulle-sde install --prefix /usr/local \
   https://github.com/mulle-concurrent/mulle-linkedlist/archive/latest.tar.gz
```

### Legacy Installation

Install the requirements:

| Requirements                                 | Description
|----------------------------------------------|-----------------------
| [mulle-c11](https://github.com/mulle-c/mulle-c11)             | 🔀 Cross-platform C compiler glue (and some cpp conveniences)
| [mulle-allocator](https://github.com/mulle-c/mulle-allocator)             | 🔄 Flexible C memory allocation scheme
| [mulle-thread](https://github.com/mulle-concurrent/mulle-thread)             | 🔠 Cross-platform thread/mutex/tss/atomic operations in C

Download the latest [tar](https://github.com/mulle-concurrent/mulle-linkedlist/archive/refs/tags/latest.tar.gz) or [zip](https://github.com/mulle-concurrent/mulle-linkedlist/archive/refs/tags/latest.zip) archive and unpack it.

Install **mulle-linkedlist** into `/usr/local` with [cmake](https://cmake.org):

``` sh
PREFIX_DIR="/usr/local"
cmake -B build                               \
      -DMULLE_SDK_PATH="${PREFIX_DIR}"       \
      -DCMAKE_INSTALL_PREFIX="${PREFIX_DIR}" \
      -DCMAKE_PREFIX_PATH="${PREFIX_DIR}"    \
      -DCMAKE_BUILD_TYPE=Release &&
cmake --build build --config Release &&
cmake --install build --config Release
```


## Author

[Nat!](https://mulle-kybernetik.com/weblog) for Mulle kybernetiK  



