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
  * These are called *static variables*
* *Persistent variables*: variables with lifetimes that extend across multiple executions of the program
### 12.3 Activation Records
* Multiple activations can be live at the same time in a single-threaded program, i.e. one function calls another. Of course, they aren't *executing* at the same time, however
* *Return address*: location within the calling function's code where execution should resume when the called function returns
* Language implementations usually gather all activation-specific variables and other activation-specific data together into one block of memory called the *activation record*
### 12.4 Static Allocation of Activation Records
* Simple way to handle activation records: allocate one for each function, statically
  * Find out how much space each item takes up (variables, return addresses) and allocate a static block in memory
  * Advantages: simplest solution, programs are slightly faster
  * Drawbacks: the system will fail if there is ever more than one activation of the function alive at the same time. Recursion would not work
### 12.5 Dynamic Stacks of Activation Records
* For languages that support recursion, activation records need to be allocated dynamically
* Activation record may be dallocated when the function returns
* Activation records form a stack at runtime, they are pushed on call and popped on return
  * This system is known as *stack frames*
* Since activation records are now dynamically allocated, their addresses can't be known at compile time. Instead a machine register is dedicated to this purpose at runtime. When a function returns, two addresses are important now:
  1. The address of the machine code to return to in the calling function
  2. The address of the activation record that function was using
### 12.6 Handling Nexted Function Definitions
* Dynamic allocation of activation records is enough for C, but not for languages like Pascal and ML, which allow nested function definitions with non-local references
* Address of the most recent activation record for the function within which the function's definition is nested = *nesting link*
  * When calling a top-level function, nesting link for the called activation is set to null
  * When calling from a top-level function to a nested function, set the nesting link to the address of the caller's activation record
  * When calling from a nested function to a nested function, set the nesting link for the called activation the same as the caller's nesting link
### 12.7 Functions as Parameters
* Pass both the implementation and the nesting link to use a function being passed in as a parameter
* ML allows you to do this, C allows you to pass the address of a function as a parameter
  * No nesting link is required since functions cannot be nested
### 12.8 Long-Lived Functions
* Requires garbage collection
### 12.9 Conclusion
* For languages that do not allow more than one activation of a function to be alive at once (no recursion), you can allocate activation records statically
* For languages that do allow more than one activation of a function to be alive at once, you can allocate activation records dynamically. The natural behavior of a function calls and returns produces a stack of activation records. A new activation record is pushed when a function is called and popped when it returns. This works in C.
* Languages that allow non-local references from nested function definitions need additional support. One way to handle this is with an additional field in the activation record - the nesting link. This is needed for Pascal, Ada, and ML.
* For languages that allow references into activation records for activations that have returned, you need to be aware that activation records cannot necessarily be deallocated and reused when they are popped off the stack. This happens in languages like ML, when a function value persists after the function that created it has returned
