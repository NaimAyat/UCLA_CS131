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
## Grammars
* Way to describe which strings are and aren't valid for a language
* Terminal symbol - a symbol that can't be replaced with other symbols
* Nonterminal symbol - a symbol that can be replaced with other symbols
* Rule - a list of symbols that can replace a nonterminal symbol
* Grammar - a starting symbol and a set of rules that describe which symbols can be derived from a nonterminal
## Derivations
* Phrase/Fragment: a list of terminal values (ex. `["3";"+";"4"]`)
