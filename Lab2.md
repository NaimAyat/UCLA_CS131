# Lab 2 (January 19, 2018)
## OCaml
* Static typing -> catch errors at compile time
* Type erasure -> most type info is erased before program is run
* Type inference -> system figures out type annotations for you
### Tuples
Unlike lists, tuples can contain mixed types. However, they have fixed length.
```
# let tuple = (1, "hello");;
```
