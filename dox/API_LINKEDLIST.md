# `struct mulle_linkedlist`

**`mulle_linkedlist`** is a linked list data structure along with several functions to manipulate it. The main components of this code are:

- `struct _mulle_concurrent_linkedlistentry`: Represents a single entry in the linked list, containing a pointer to the next entry.
- `struct _mulle_concurrent_linkedlist`: Represents the linked list itself, containing a head pointer to the first entry.
- `_mulle_concurrent_linkedlist_init()`: Initializes a linked list.
- `_mulle_concurrent_linkedlist_done()`: Cleans up a linked list.
- `_mulle_concurrent_linkedlist_add()`: Adds an entry to the linked list.
- `_mulle_concurrent_linkedlist_remove_all()`: Removes all entries from the linked list and returns the previous head.
- `_mulle_concurrent_linkedlist_remove_one()`: Removes one entry from the linked list and returns it.
- `_mulle_concurrent_linkedlist_walk()`: Iterates through the linked list and calls a provided callback function for each entry.

In these functions, atomic operations are used to ensure thread safety when manipulating the linked list in a concurrent environment. You can learn more about atomic operations from [Source 3](http://www.mulle-kybernetik.com/weblog/2015/mulle_aba_how_it_works_2.html).


## Functions

### `_mulle_concurrent_linkedlist_init`

```c
static inline void _mulle_concurrent_linkedlist_init( struct _mulle_concurrent_linkedlist *p);
```

- **Parameters:**
  - `p`: A pointer to a `_mulle_concurrent_linkedlist` structure that needs to be initialized.
- **Return value:** None.
- **Functionality:** Initializes a `_mulle_concurrent_linkedlist` structure by setting all its memory to zero.

### `_mulle_concurrent_linkedlist_done`

```c
static inline void _mulle_concurrent_linkedlist_done( struct _mulle_concurrent_linkedlist *p);
```

- **Parameters:**
  - `p`: A pointer to a `_mulle_concurrent_linkedlist` structure that needs to be de-initialized.
- **Return value:** None.
- **Functionality:** De-initializes a `_mulle_concurrent_linkedlist` structure by asserting that the head pointer is NULL (i.e., the list is empty).

### `_mulle_concurrent_linkedlist_add`

```c
void _mulle_concurrent_linkedlist_add( struct _mulle_concurrent_linkedlist *list, struct _mulle_concurrent_linkedlistentry *entry);
```

- **Parameters:**
  - `list`: A pointer to the `_mulle_concurrent_linkedlist` structure to which the entry will be added.
  - `entry`: A pointer to the `_mulle_concurrent_linkedlistentry` structure to be added to the list.
- **Return value:** None.
- **Functionality:** Adds an entry to the back of the given linked list in a thread-safe manner using atomic operations.

### `_mulle_concurrent_linkedlist_remove_all`

```c
struct _mulle_concurrent_linkedlistentry * _mulle_concurrent_linkedlist_remove_all( struct _mulle_concurrent_linkedlist *list);
```

- **Parameters:**
  - `list`: A pointer to the `_mulle_concurrent_linkedlist` structure from which all entries will be removed.
- **Return value:** A pointer to the head of the removed linked list entries, or NULL if the list was empty.
- **Functionality:** Removes all entries from the given linked list in a thread-safe manner using atomic operations.

### `_mulle_concurrent_linkedlist_remove_one`

```c
struct _mulle_concurrent_linkedlistentry * _mulle_concurrent_linkedlist_remove_one( struct _mulle_concurrent_linkedlist *list);
```

- **Parameters:**
  - `list`: A pointer to the `_mulle_concurrent_linkedlist` structure from which one entry will be removed.
- **Return value:** A pointer to the removed `_mulle_concurrent_linkedlistentry` structure, or NULL if the list was empty.
- **Functionality:** Removes one entry from the given linked list in a thread-safe manner using atomic operations. The returned `_link` field will be zeroed.

### `_mulle_concurrent_linkedlist_walk`

```c
int _mulle_concurrent_linkedlist_walk( struct _mulle_concurrent_linkedlist *list, int (*callback)( struct _mulle_concurrent_linkedlistentry *, struct _mulle_concurrent_linkedlistentry *, void *), void *userinfo);
```

- **Parameters:**
  - `list`: A pointer to the `_mulle_concurrent_linkedlist` structure that will be walked.
  - `callback`: A function pointer to a callback function that will be called for each entry in the list. The callback function should have the following signature: `int callback( struct _mulle_concurrent_linkedlistentry *entry, struct _mulle_concurrent_linkedlistentry *prev, void *userinfo)`.
  - `userinfo`: A pointer to user data that will be passed to the callback function.
- **Return value:** The return value of the last callback function called, or 0 if the list was empty or the walk completed without interruption.
- **Functionality:** Walks through the given linked list and calls the provided callback function for each entry. Note that this function is not thread-safe.
