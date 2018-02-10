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
  * Lowercase letters describe predicates and atoms
  * Variables must start with an uppercase
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
