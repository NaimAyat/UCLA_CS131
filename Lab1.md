# Lab 1 (January 12, 2018)
## Logistics
* sakekasi@ucla.edu
* OH: Mon/Tues 9:30-10:30 @ Boelter 2432
## OCaml
* Install at https://ocaml.org
* Or use SEASnet installation (UCLA-specific)
  * http://www.seasnet.ucla.edu/lnxsrv/
  * use lnxsrv06, lnxsrv07, lnxsrv09
* Recommended text: https://realworldocaml.org
* Static typing
  * Catches lots of programmer errors at compile time
* Typer inference
  * The system figures out type annotations for you
* Functional programming
  * More terse and easier to reason about
* Used widely in industry
* No pointers/objects in this class
### Variable Assignment & Arithmetic
* A program is a sequence of bindings
  ```
  let x = 5
  let y = x + 1
  let z = x * y
  ```
* Evaluate the expression to the right in the environment created by the previous bindings. Bind the variable on the left to the value of the expression on the right.
* You cannot re-define variables.
* Each statement ends with two semicolons.
```
# 2 + 15
  ;;
- : int = 17
```
* `+` operator only can add ints. `+.` operator can only add floats.
```
# 2.0 +. 15.0
  ;;
- : float = 17
```
* To assign variables, use `let`
```
# let d = true;;
val d : bool = true
```
### Conditionals
* Use `if` in the style of C ternary operator
```
# if true then 1 else 0;;
- : int = 1
```
* OCaml expects the `if` and `then` expressions to have the same type
```
# if 1 < 2 then "less" else 3;;
Error: This expression has type int but an expression was expected of type string
```
### Functions
* Use `let`
```
let doubleMe x = x + x;;
val doubleMe : int -> int = <fun>
```
```
# doubleMe(5);;
- : int = 10
```
```
# doubleMe 5;;
- : int = 10
```
#### Multiple Argument Functions
```
# let doubleUs x y = x*2 + y*2;;
val doubleUs : int -> int -> int = <funct>
```
#### Example
* Define a function that takes two integer arguments and returns the higher value
```
let findMax x y = if x > y then x else y;;
val max : 'a -> 'a -> 'a = <fun>
```
* `'a` is a *type variable*. In other words, the function can handle any input type.
### Creating .ml Files
* Don't need `;;` after each line, only necessary in command line
### Anonymous Functions
```
let double = fun x -> x * x;;
val double : int -> int = <fun>
```
* Can define throwaway functions to use in single terminal command
### Lists
* Empty list `[]`
```
# let list1 = [];;
val list1: 'a list = []
```
```
# let list2 = [1; 2; 3];;
val list2 : int list = [1; 2; 3]
```
* To append, use `::`
```
# 1 :: [];;
- : int list = [1]
```
* To concatenate: use `@`
```
# [1; 2; 3] @ [4; 5; 6]
- : int list = [1; 2; 3; 4; 5; 6]
```
