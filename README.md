# mulle-linkedlist

#### 🔂 mulle-linkedlist a wait and lock-free linked list

mulle-linkedlist is a barebones lock- and wait-free linked list that is used
by mulle-aba and the mulle-objc-runtime.

| Release Version                                       | Release Notes
|-------------------------------------------------------|--------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag//mulle-linkedlist.svg?branch=release) [![Build Status](https://github.com//mulle-linkedlist/workflows/CI/badge.svg?branch=release)](//github.com//mulle-linkedlist/actions)| [RELEASENOTES](RELEASENOTES.md) |


## API

| Data Structure                                         | Description
| -------------------------------------------------------|----------------------------
| [`mulle-concurrent-linkedlist`](dox/API_LINKEDLIST.md) | A wait and lock free linked list








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

### Install with mulle-sde

Use [mulle-sde](//github.com/mulle-sde) to build and install mulle-linkedlist and all dependencies:

``` sh
mulle-sde install --prefix /usr/local \
   https://github.com///archive/latest.tar.gz
```

### Manual Installation

Install the requirements:

| Requirements                                 | Description
|----------------------------------------------|-----------------------
| [mulle-c11](https://github.com/mulle-c/mulle-c11)             | 🔀 Cross-platform C compiler glue (and some cpp conveniences)
| [mulle-allocator](https://github.com/mulle-c/mulle-allocator)             | 🔄 Flexible C memory allocation scheme
| [mulle-thread](https://github.com/mulle-concurrent/mulle-thread)             | 🔠 Cross-platform thread/mutex/tss/atomic operations in C

Install **mulle-linkedlist** into `/usr/local` with [cmake](https://cmake.org):

``` sh
cmake -B build \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_PREFIX_PATH=/usr/local \
      -DCMAKE_BUILD_TYPE=Release &&
cmake --build build --config Release &&
cmake --install build --config Release
```

## Author

[Nat!](https://mulle-kybernetik.com/weblog) for Mulle kybernetiK


