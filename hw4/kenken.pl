% Homework 4. KenKen Solver

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% kenken/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% kenken/3 uses the gprolog finite domain solver and accepts these arguments:
%     N, a nonnegative integer specifying the number of cells on each side of 
%        the KenKen square
%     C, a list of numeric cage constraints
%     T, a list of list of integers. All the lists have length N. This 
%        represents the N×N grid.

kenken(N, C, T) :-
    length(T, N), maplist(getSize(N), T),
    maplist(domain(N), T),
    maplist(constraints(T), C),
    maplist(fd_all_different, T),
    transpose(T, T2), maplist(fd_all_different, T2),
    maplist(fd_labeling, T).

% Defined constraints for plain kenken
constraints(T, C) :- 
    matchConstraint(T, C).
        matchConstraint(T, +(Res, L)) :- 
            add(T, Res, L, 0).
        matchConstraint(T, *(Res, L)) :- 
            mult(T, Res, L, 1).
        matchConstraint(T, -(Res, J, K)) :- 
            sub(T, Res, J, K).
        matchConstraint(T, /(Res, J, K)) :- 
            div(T, Res, J, K).

% Finds transpose of a matrix, source: clpfd.pl
transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).
transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
    lists_firsts_rests(Ms, Ts, Ms1),
    transpose(Rs, Ms1, Tss).
lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
    lists_firsts_rests(Rest, Fs, Oss).

% Helper function that gets the size of an object
getSize(Size, Object) :- 
    length(Object, Size).

% Helper function that sets the domain using fd
domain(N, L) :- 
    fd_domain(L, 1, N).

% Helper function that accesses a certain coordinate on the matrix
getCoordinate([I|J], T, V) :- 
    nth(I, T, R), nth(J, R, V).

% Non-plain addition definition using #=
add(_, Res, [], Res).
add(T, Res, [Head|Tail], Itr) :- 
    getCoordinate(Head, T, Val), 
    Itr2 #= Itr + Val, 
    add(T, Res, Tail, Itr2).

% Non-plain multiplication definition using #=
mult(_, Res, [], Res).
mult(T, Res, [Head|Tail], Itr) :-
    getCoordinate(Head, T, V),
    Itr2 #= Itr * V,
    mult(T, Res, Tail, Itr2). 

% Non-plain subtraction definition using #=
sub(_, Res, _, _, Res).
sub(T, Res, J, K) :-
    getCoordinate(J, T, A),
    getCoordinate(K, T, B),
    Itr #= A - B,
    sub(T, Res, J, K, Itr).
% Requires a second definition because subtraction is not commutative
sub(T, Res, J, K) :-
    getCoordinate(J, T, A),
    getCoordinate(K, T, B),
    Itr #= B - A,
    sub(T, Res, J, K, Itr).

% Non-plain division definition using #=
div(_, Res, _, _, Res).
div(T, Res, J, K) :-
    getCoordinate(J, T, A),
    getCoordinate(K, T, B),
    Itr #= A / B,
    div(T, Res, J, K, Itr).
% Requires a second definition because division is not commutative
div(T, Res, J, K) :-
    getCoordinate(J, T, A),
    getCoordinate(K, T, B),
    Itr #= B / A,
    div(T, Res, J, K, Itr).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plain_kenken/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plain_kenken/3 acts exactly like kenken/3, but does not use gprolog fd solver
plain_kenken(N, C, T) :-
    length(T, N), maplist(getSize(N), T),
    new_mapList(N, L), maplist(permutation(L), T),
    transpose(T, T2), maplist(all_different, T2),
    maplist(constraints(T), C).

% non-fd implementation of fd_all_diffferent
all_different([]).
all_different([Head|Tail]) :- 
    \+(member(Head, Tail)), all_different(Tail).

% non-fd helper for maplist
new_mapList(N, L) :- 
    findall(Num, between(1, N, Num), L).

% Constraints (Plain)
constraints_p(T, C) :- 
    matchConstraint_p(T, C).
    matchConstraint_p(T, +(Res, L)) :- 
        plainAdd(T, Res, L, 0).
    matchConstraint_p(T, *(Res, L)) :- 
        plainMult(T, Res, L, 1).
    matchConstraint_p(T, -(Res, J, K)) :- 
        plainSub(T, Res, J, K).
    matchConstraint_p(T, /(Res, J, K)) :- 
        plainDiv(T, Res, J, K).

% Same definition of addition as above, using is instead of #=
plainAdd(_, Res, [], Res).
plainAdd(T, Res, [Head|Tail], Itr) :- 
    getCoordinate(Head, T, V), 
    Itr2 is Itr + V, 
    plainAdd(T, Res, Tail, Itr2).

% Same definition of multiplication as above, using is instead of #=
plainMult(_, Res, [], Res).
plainMult(T, Res, [Head|Tail], Itr) :-
    getCoordinate(Head, T, V),
    Itr2 is Itr * V,
    plainMult(T, Res, Tail, Itr2). 

% Same definition of subtraction as above, using is instead of #=
plainSub(_, Res, _, _, Res).
plainSub(T, Res, J, K) :-
    getCoordinate(J, T, A),
    getCoordinate(K, T, B),
    Itr is  A - B,
    plainSub(T, Res, J, K, Itr).
% Requires a second definition because subtraction is not commutative
plainSub(T, Res, J, K) :-
    getCoordinate(J, T, A),
    getCoordinate(K, T, B),
    New_accumulator is  B - A,
    plainSub(T, Res, J, K, Itr).

% Same definition of division as above, using is instead of #=
plainDiv(_, Res, _, _, Res).
plainDiv(T, Res, J, K) :-
    getCoordinate(J, T, A),
    getCoordinate(K, T, B),
    Itr is A / B,
    plainDiv(T, Res, J, K, Itr).
% Requires a second definition because division is not commutative
plainDiv(T, Res, J, K) :-
    getCoordinate(J, T, A),
    getCoordinate(K, T, B),
    Itr is B / A,
    plainDiv(T, Res, J, K, Itr).

kenken_testcase(
  6,
  [
   +(11, [[1|1], [2|1]]),
   /(2, [1|2], [1|3]),
   *(20, [[1|4], [2|4]]),
   *(6, [[1|5], [1|6], [2|6], [3|6]]),
   -(3, [2|2], [2|3]),
   /(3, [2|5], [3|5]),
   *(240, [[3|1], [3|2], [4|1], [4|2]]),
   *(6, [[3|3], [3|4]]),
   *(6, [[4|3], [5|3]]),
   +(7, [[4|4], [5|4], [5|5]]),
   *(30, [[4|5], [4|6]]),
   *(6, [[5|1], [5|2]]),
   +(9, [[5|6], [6|6]]),
   +(8, [[6|1], [6|2], [6|3]]),
   /(2, [6|4], [6|5])
  ]
).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EFFICIENCY TEST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% kenken/3 yielded the following results for a 4x4 test case:
% User Time: 0.002 seconds
% System Time: 0.002 seconds
% CPU Time: 0.004 seconds
% Real Time: 3.013 seconds
%
% plain_kenken/3 yielded the following results for the same 4x4 test:
% User Time: 0.783 seconds
% System Time: 0.011 seconds
% CPU Time: 0.790 seconds
% Real Time: 28.941 seconds
%
% Hence, we see that kenken/3 yields much better performance than plain_kenken.
% This is a logical result of plain_kenken failing to utilize finite domains. 
% Its search space is much larger than that of kenken/3; hence it is not as 
% efficient for obtaining a solution.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% noop_kenken %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% noop_kenken/4 should take the following arguments:
%
% noop_kenken(N, C, C2, T)
%     N: a nonnegative integer specifying the number of cells on each side of
%        the KenKen square.
%     C: a list of numeric cage constraints. Each constraint is (T, L) where T 
%        is the target number and L is a list of squares that, for some 
%        arithmetic operation, the list evaluates to T.
%    C2: list of numeric cage constraints appended to its corresponding
%          operator. C2 is equivalent kenken/3's C. The list is as follows:
%          +(S, L), *(P, L), -(D, J, K), (Q, J, K).
%     T: a list of integers, each of length N. This represents the grid.
%
% With this API, we can provide a test case nearly identical to the one above,
% barring the inclusion of operators.

noop_kenken_testcase(
  6,
  [
   (11, [[1|1], [2|1]]),
   (2, [1|2], [1|3]),
   (20, [[1|4], [2|4]]),
   (6, [[1|5], [1|6], [2|6], [3|6]]),
   (3, [2|2], [2|3]),
   (3, [2|5], [3|5]),
   (240, [[3|1], [3|2], [4|1], [4|2]]),
   (6, [[3|3], [3|4]]),
   (6, [[4|3], [5|3]]),
   (7, [[4|4], [5|4], [5|5]]),
   (30, [[4|5], [4|6]]),
   (6, [[5|1], [5|2]]),
   (9, [[5|6], [6|6]]),
   (8, [[6|1], [6|2], [6|3]]),
   (2, [6|4], [6|5])
  ]
).
