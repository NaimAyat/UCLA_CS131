# Lab (Feb 9, 2018)
## Prolog
* GProlog used in this class (not SWI-Prolog)
* Declarative language
  * State high-level goals, not how to achieve them
* Declare a database of facts/rules
* Make logical queries on this database
* Try facts/rules in order and *unify* query with database
* To open, type `gprolog`
### Examples
* Ex 1:
  ```
  person(alice).
  person(bob).
  ```
  * Things that look like functions are "predicates".
  * Save as `people.pl`
  * Type: `?- person(alice).` Returns `yes`
* Ex 2:
  ```
  father(orville, abe).
  father(abe, homer).
  father(homer, bart).
  father(homer, lisa).
  father(homer, maggie).
  grandfather(X, Y) :-
    father(X, Z),
    father(Z, Y).
  ```
  * `:-` is like an `if`
  * Now ask: `?- grandfather(abe, bart).` Returns `yes`.
  * Now ask: `?- grandfather(abe, Grandkid).` Returns
    ```
    Grandkid = bart ? ;
    Grandkid = lisa ? ;
    Grandkid = maggie ? ;
    yes
    ```
### Syntax
* Predicates
  * Relations that are true or faslse
* Lowercase letters describe predicates and atoms
* Variables must start with an uppercase
* `conclusion :- hypothesis.`
  * Multiple hypotheses separated by commas
  * Conclusion is only true if all hypotheses are true
* And operator `,`
* Or operator `;`
#### Example
* Write a `birthparents` predicate that has 3 variables, `Child`, `Mother`, and `Father`, and uses the `mother` and `father` predicate.
  ```
  birthparents(Father, Mother, Child) :-
    father(Father, Child).
    mother(Mother, Child).
  ```
### Lists
* `head(cons(X, XS), X).`
  * `?- head(cons(1, empty), X).` returns `1`
  * `?- head(cons(1, 5), X).` returns `1`
* `tail(cons(X, XS), XS).`
  * `?- tail(cons(1, empty), X).` returns `empty`
  * `?- tail(cons(1, 5), X).` returns `5`
  * `?- head(List, 1).` returns `List - cons(1,_)`
* `mylength(empty, 0).`
* ```
  mylength(cons(X, XS), Y) :-
    mylength(XS, LXS),
    Y is LXS + 1.
  ```
