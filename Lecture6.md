# Lecture 6 (Feb 13, 2018)
## Types of Languages
* Imperative: C++, Java
* Functional: Lisp, ML
* Logic: Prolog
  * Just logic, focus on predicates
* Algorithm = Logic (correctness) + Control (efficiency)
#### Example: Sort
```
sort(L,S) :- perm(L,S), sorted(S).
```
Note: `:-` denotes `if`, `,` denotes `and`
