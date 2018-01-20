# Lab 2 (January 19, 2018)
## OCaml
* Static typing -> catch errors at compile time
* Type erasure -> most type info is erased before program is run
* Type inference -> system figures out type annotations for you
### Tuples
Unlike lists, tuples can contain mixed types. However, they have fixed length.
```
# let myTuple = (1, "hello");;
```
### Tail Recursion
* Regular recursive example:
  ```
  # let rec filter list predicate -> match list with
    | [] -> []
    | h::t -> if predicate h then h::(filter t predicate) else filter t predicate
  ```
* Tail recursive equivalent:
  ```
  # let rec filter2 l p aggregate = match l with
    | [] -> aggregate
    | h::t -> if p h then (filter t p (h::aggregate)) else (filter t p aggregate)
  ```
