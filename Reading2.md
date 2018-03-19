# *Modern Programming Languages, 2nd Edition* (Webber)
# Chapters 12, 14, 16, 18-23
## Chapter 12: Memory Locations for Variables
### 12.1 Intro
* In languages without assignment (like ML) the fact that variables are associate with memory is more hidden
* Each variable needs at least one memory location
### 12.2 Activation-Specific Variables
* Most languages have a way to declare a variable bound to a memory location
* ML example:
```
fun days2ms days =
  let
    val hours = days * 24.0
    val mins = hours * 60.0
    val seconds = mins * 60.0
  in 
    seconds * 1000.0
end;
```
  * When the function is called, memory locations are needed to hold the values of `days`, `mins`, `seconds`. 
  * The variables may not be bound to the same memory locations in later calls
* A lifetime of one function call is called an *activation* of the function
* Variables in the previous example are *activation specific*; local variables usually are by default
* It is possible for an activation-specific variable to not get a spot in memory, i.e. if it is never used
#### Other Kinds of Variables
* Most imperative languages allow you to declare a variable that is bound to one memory location for the entire runtime of the program, like a variable declared outside a function in C
