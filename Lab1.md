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
