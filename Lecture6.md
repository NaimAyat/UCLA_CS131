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
sorted([X,Y|L]) :- X =< Y, sorted(Y|L).
perm([],[]).
perm([X],[X]).
perm([X,Y],[X,Y]).
perm([X,Y],[Y,X]).
perm([X,L], S). %Above 4 lines no longer necessary
  append(S1, [X|S2], S),
  perm(L,S1S2),
  append(S1,S2,S1S2).
  append([],L,L)/
  append([X|L]),M,[X|LM]) :- append(L,M,LM).
```
* `:-` denotes `if`; `,` denotes `and`
* Each clause must end in `.`
