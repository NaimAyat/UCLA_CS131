# Lecture 6 (Feb 13, 2018)
## Types of Languages
* Imperative: C++, Java
* Functional: Lisp, ML
* Logic: Prolog
  * Just logic, focus on predicates
* Algorithm = Logic (correctness) + Control (efficiency)
#### Example: Prolog Sort
```
sort(L,S) :- perm(L,S), sorted(S).
sorted([]).
sorted([_]).
sorted([X,Y|L]) :- X =< Y, sorted(L).
```
* `:-` denotes `if`; `,` denotes `and`
* Each clause must end in `.`