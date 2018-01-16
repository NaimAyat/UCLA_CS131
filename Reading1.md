# *Modern Programming Languages, 2nd Edition* (Webber)
# Chapters 1, 2, 3, 5, 7 , 9, & 11
## Chapter 1
### 1.2 Variety
* Imperative language: supports assignment and iteration (ex. C)
* Functional language: supports recursion and single-valued variables (ex. ML, Lisp)
  * Recursion is as natural in ML as iteration is in C
* Logic language: programs written in terms of rules about logical inference (ex. Prolog)
  * Not well-suited for computing mathematical functions
* Object-oriented language: in addition to being imperative, it is easier to define objects (ex. C++, Java)
* Multi-paradigm languages: attempt to combine features of multiple language types (ex. JavaScript, OCaml, Python)
### 1.3 Controversies
* The definition of *object-oriented* is heavily debated; some languages may be considered more object-oriented than others
### 1.4 Evolution
* Good languages can evolve new dialects (ex. Fortran II through Fortran 2008)
### 1.5 Connections
* It is best to adapt programming style to the language in use (ex. write many small functions in ML, use objects in Java)
## Chapter 2
### 2.1 Introduction
* Syntax - defines program form and structure
* Semantics - defines what programs do; their behavior and meaning
### 2.2 A Grammar Example for English
* We use the symbol `<A>` for article and express our definition:
```
<A> ::= a | the
```
* Similarly, the words `dog`, `cat` are nouns:
```
<N> ::= dog | cat | rat
```
* A noun phrase is an article followed by a noun:
```
<NP> ::= <A> <N>
```
* Now, we define verbs:
```
<V> ::= loves | hates | eats
```
* A sentence is a noun phrase, followed by a verb, followed by another noun phrase:
```
<S> ::= <NP> <V> <NP>
```
* Combining these definitions, we have a grammar that defines a small subset of unpunctuated English.
```
<A> ::= a | the
<N> ::= dog | cat | rat
<NP> ::= <A> <N>
<V> ::= loves | hates | eats
<S> ::= <NP> <V> <NP>
```
#### Parse Trees
* Think of the grammar as a set of rules that say how to build a tree. `<S>` is the root, and the grammar tells how children can be added at any point (node) on the tree.
* [Example parse tree from the example above](Images/parseTree.PNG)
