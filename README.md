# mulle-linkedlist

#### 🔂 mulle-linkedlist a wait and lock-free linked list

The mulle-concurrent-linkedlist is a barebones lock- and wait-free linked list,
that is used by mulle-aba and the mulle-objc-runtime. A single-threaded
variant mulle-linkedlist is also supplied.



| Release Version                                       | Release Notes  | AI Documentation
|-------------------------------------------------------|----------------|---------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-concurrent/mulle-linkedlist.svg) [![Build Status](https://github.com/mulle-concurrent/mulle-linkedlist/workflows/CI/badge.svg)](//github.com/mulle-concurrent/mulle-linkedlist/actions) | [RELEASENOTES](RELEASENOTES.md) | [DeepWiki for mulle-linkedlist](https://deepwiki.com/mulle-concurrent/mulle-linkedlist)


## API

| Data Structure                                         | Description
| -------------------------------------------------------|----------------------------
| [`mulle-concurrent-linkedlist`](dox/API_LINKEDLIST.md) | A wait and lock free linked list







### You are here

![Overview](overview.dot.svg)





## Add

**This project is a component of the [mulle-core](//github.com/mulle-core/mulle-core) library. As such you usually will *not* add or install it
individually, unless you specifically do not want to link against
`mulle-core`.**


### Add as an individual component

Use [mulle-sde](//github.com/mulle-sde) to add mulle-linkedlist to your project:

``` sh
mulle-sde add github:mulle-concurrent/mulle-linkedlist
```

To only add the sources of mulle-linkedlist with dependency
sources use [clib](https://github.com/clibs/clib):


``` sh
clib install --out src/mulle-concurrent mulle-concurrent/mulle-linkedlist
```

Add `-isystem src/mulle-concurrent` to your `CFLAGS` and compile all the sources that were downloaded with your project.


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



