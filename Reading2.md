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
## Chapter 14: Memory Management
### 14.2 Memory Model Using Java Arrays
```
int[] a = null;
```
* This declares `a` to be a reference to an array of integers and initializes it to `null`. To make `a` be a reference to an array, allocate and array and assign the reference to `a` like this: `a = new int[100]`
  * This creates a new array of 100 integer values and stores a reference to the new array in `a`
### 14.3 Stacks
* Since modern languages allow recursion, we need to allocate activation records at runtime
* Memory manager can take advantage of the stack order - the fact that the first activation record allocated will be the last one deallocated
  * Store the postition of the previous top of the stack at the top of each activation record. Now, all we have to do when an activation record is finished is to pop it and reload the `top` value from the previous record
  * Allocation and deallocation are nothing more than simple adjustments to the `top` address
  * This efficiency depends on the fact that deallocation and allocation are restricted to stack order. In languages without that restriction, memory management becomes a more difficult problem
### 14.4 Heaps
* Now, considere unordered runtime memory allocation and deallocation. The program is free to allocate and deallocate blocks in any order
  * A heap is a pool of blocks on memory, with an interface for unordered runtime memory allocation and deallocation
* The `allocate` function takes an integer parameter - the number of words of memory to be allocated - and returns the address of a newly allocated block of at least that many words
* The `deallocate` function takes the address of an allocated block - one of those addresses returned by prior calls to `allocate` and not yes deallocated - and frees up the block beginning at that address
  * This is like C's `malloc` and `free` functions
#### First-Fit Mechanism
* Heap manager maintains a linked list of free blocks, initially containing one big free block
* To allocate a block, the heap manager searches the free list for the first sufficiently larege free block. If there is extra space at the end of the block, the block is split and the unused portion at the upper end is returned to the free list. The requested portion at the lower end is allocated to the caller
* To free a block, the heap manager returns it to the front of the free list
#### Coalescing Free Blocks
* The previous mechanism breaks big blocks into little blocks, but never reverses the process
* We need to modify `deallocate` to make it coalese adjacent free blocks
* The new `deallocate` method does not just put the free block on the head of the free list, it maintains the free list sorted in  increasing order of addresses. It finds the right insertion point in this list for the newly deallocated block, inserts it into the list, and merges it with the previous free block and with the following free block if it is adjacent
#### Quick Lists and Delayed Coalescing
* Small blocks tend to be allocated and deallocated more frequently than large ones
* To improve the performance of a heap manager, have it maintain separate free lists for the popular small block sizes, called *quick lists*
#### Fragmentation 
* Problem: free blocks are not adjacent; the disk is fragmented
#### Other Heap Mechanisms
* A heap manager must decide a *placement* for every block allocated. When it sees a request to allocate a block, the allocator usually has many positions in memory to choose from. The simple mechanism of first-fit allocation is only one of the many ways to make that choice. Some use data structures such as balanced binary trees.
* A heap manager usually implements block *splitting*; if it decides to allocate a block within a free region of memory that is larger than the requested size, it has more choices to make. It can allocate exactly the requested amount, leaving the rest as a free block. However, a heap manager can get better performance by doing less splitting.
  * If the requested amount is nearly the same size as the free block, it makes sense to just go ahead and use the whole thing
* Block *coalescing*: when adjacent blocks are free, the heap manager can decide to combine them into a single free block, but the heap manager gets better performance by doing less coalescing. If a small block is deallocated of a popular size, it will probably be needed again - it makes sense not to coalesce it
### 14.5 Current Heap Links
* *Current heap link*: memory location where a value is stored that the running program will use as a heap address
* To trace current heap links:
  1. Start with the root set, the set of memory locations all of the running program's variables, including all those statically allocated and those in activation records for activations that have not yet returned. Omit all those whose values obviously cannot be used as heap addresses.
  2. For each memory location in the set, look at the allocated block it points to and add all the memory locations within that block, but omit those whose values obviously cannot be used as heap addresses. Repeat this until no new memory locations are found.
* Tracing heap links yields three types of errors:
  1. Exclusion errors: a memory location that actually is a current heap link is accidentally excluded from the set
  2. Unused inclusion errors: a memory location is included in the set, but the program never actually uses the value stored there
  3. Used inclusion errors: a memory location is included in the set, but the program uses the value stored there as something other than a heap addres; as an integer, for example
* When we find something that might be used as a heap link we must include it, even though the program might not actually use it at all
#### Heap Compaction
* Some heap managers perform heap compaction: moving allocated blocks around without disturbing the running program. The block is simply copied to a new location, then it updates all the current heap links to the old block, making them point to the new location
  * This eliminates fragmentation of the heap
  * It is expensive, so it is usually only done as a last resort; for example, if some allocation is about to fail
#### Garbage Collection
* *Dangling pointer*: a pointer to a block that is no longer allocated
  * Causes a memory leak
* Garbage collection: heap manager finds the allocated block that the running program is no longer using and claims them automatically. Three basic techniques:
  1. Mark-and-sweep: garbage collector traces current heap links and marks all the allocated blocks that are the targets of those links. In the sweep phase, the collecotr makes a pass over the heap, finding all blocks that did not get marked and adding them to the free list. Mark-and-sweep does not move allocated blocks; the heap remains fragmented after garbage collection. For this reason, they can tolerate both kinds of inclusion errors. Extra inclusions in the current heap simply cause some garbage blocks to be retained.
     * Cons: Give uneven performance - usually good, with occasional long pauses while the heap manager collects garbage. For time-sensitive systems, this is unacceptable. *Incremental collectors* recover a little garbage at a time, while the program is running, instead of doing it all at once in response to some memory allocation
  2. Copying collector: heap manager uses only half of its available memory at a time. When that half becomes full, it finds the current heap links and copies all the non-garbage blocks into the other half. It compacts as it goes, so in the new half all the allocated blocks are together and all the free space is in a single free block. Then it resumes normal allocation in the new half. When that half becomes full, it repeats the process, copying and compacting back into the other half. Copying collectors do move allocated blocks, so they are sensitive to inclusion errors.
  3. Reference-conting collector: does not need to trace current heep links. Every allocated heap block includes a counter that keeps track of how many copies of its addresses there are. The language system maintains these reference counters, incrementing them when a free reference is copied, and decrementing them when a reference is discareded. When a reference counter becomes zero, that block is known to be garbage and can be freed. Reference-counting systems suffer from poor performance generally, since maintaining the reference counters adds overhead to simple pointer operations. They also cannot collect cycles of garbage.
## Chapter 16: Object Orientation
### 16.1 Introduction
* Object-oriented programming is not the same as programming in an object-oriented language
* Object-oriented languages are not all  like Java
### 16.2 Object-Oriented Programming
* You can program in an object-oriented style in virtually any language
* You can use an object-oriented language in a non-object oriented way
#### Object-Oriented ML
* Objects implemented as functions
* Curried functions: supplying parameters results in an object
#### Non-Object-Oriented Java
* Classes with no methods or constructors; all fields are public
* Drawbacks: programming the same branching structure, over and over, is tedious and error-prone
### 16.3 A Menagerie of Object-Oriented Language Features
#### Classes
* Classes group fields and methods that a set of object has. This is central to the description of an object - a bundle of data that knows how to do things to itself
* A class is instantiable. That is, a running program can create as many objects of the class as it needs. A class contains the constructors that the program can use to allocate and initialize new objects of that class. A class is like a mold for objects. The cunstructors stamp out new objects using that mold.
* A class is the unit of inheritance. A derived class inherits, as a group, the fields and methods of its base class.
* In statically type checked languages, a class can serve as a type. Objects can have a class or superclass as their static type
* Some languages, including Java, allow classes to include static fields and methods. Static fields have only one instance, not one per object. Static methods are called without an object of the class to operate on, so they can access static fields only
* A class can serve as a labeled namespace. In some languages, a class can control the degree to which its contents are visible outside of the class
#### Protoypes
* A protype is just an objec tthat is copied to make other, similar objects
* Prototype-based languages have constructs for creating objects from scratch and for making modified copies of existing objects
#### Inheritance
* Simple concept: a derived class gets things from the base class. Here's where languages differ:
  * Can a derived class have more than one base class (multiple inheritance)? Yes: C++, CLOS, Eiffel. No: Java, Smalltalk.
  * Must a derived class inherit all the methods and fields of the base class, or can it choose? All: Java. Choose: Sather.
  * Is there a common root to the inheritance hierarchy - a class from which all other classes inherit? Yes: Java, the class `Object`. No: C++.
  * What happens when a derived class has a method or field definition with the same name and type as an inherited one? In Java, the derived class can sometimes override inherited definitions. However, a method in the base class can be declared `final`, meaning no overriding is permitted.
  * Does a derived class inherit specification from the base class? In Java, a derived class inherits a collection of method obligations from the base class. 
  * Does a derived class inherit membership in types from the base class? In Java, a derived class inherits membership in all types of the base class.
* Prototype-based languages cannot have inheritance in the usual sense, since they do not have classes. The corresponding mechanism is called *delegation*. When an object gets a method call it cannot handle, it can delegate it to another object.
#### Encapsulation
* Without encapsulation, every part of a program is visible to every other part; this makes large programs extremely difficult to develop and maintain.
#### Polymorphism
* When objects of different classes have a method of the same name and type, it makes sense to be able to call that method in contexts where the exact class of the object is not known at compile time
* Subclasses can define their own unique behaviors and yet share some of the same functionality of the parent class
* Not knowing the exact class at compile time, the language system must defer the implementation decision until runtime. This is called *dynamic dispatch*. C++ offers it as an option; it is always used in Java and most OO languages.
## Chapter 18: Parameters
### 18.1 Introduction
* Actual parameters: parameters passed at the point of a call
* Formal parameters: the variables in the called method that correspond to actual parameters
### 18.2 Correspondence
* How does a language decide which formal parameters go with which actual parameters?
  * In the simplest case, it is determined by their positioned in the parameter list, *positional parameters*. Languages: Java, ML, Prolog.
  * Some languages offer additional parameter-passing features, like *keyword parameters*. In Ada: `DIVIDE(DIVIDEND => X, DIVISOR => Y);`. Others: Lisp, Dylan, Python, recent Fortran.
* Some languages allow us to declare default values of parameters, like in C++: `int f(int a = 1, int b = 2)`
* Some languages (C, C++, Perl, Python, Javascript) allow actual parameter lists of any length: `int printf(char *format, ...)`
### 18.3 By Value
* For by-value parameter passing, the formal parameter is just like a local variable in the activation record of the called method. The important difference: it is initialized using the value of the corresponding actual parameter, before the called method begins executing
* The caller and callee have two independent variables with the same value. If the callee modifies the parameter variable, the effect is not visible to the caller.
* When parameters are passed by value, changes to the formal parameter do not affect the corresponding actual parameter.
### 18.4 By Result
* A parameter passed by result is just like a local variable in the acivation record of the called method - it is uninitialized. After the called method finishes executing, the final value of the formal parameter is assigned to the corresponing actual parameter.
### 18.5 By Value-Result
* The formal parameter is just like a local variable in the activation record of the called method. It is initialized using the value of the actual called parameter, before the called method begins executing. Then, after the called method finishes executing, the final value of the formal parameter is assigned to the actual parameter.
### 18.6 By Reference
* The caller and the callee use the same variable for the parameter. If the callee modifies the parameter variable, the effect is visible to the caller's variable. The formal parameter is an alias for the actual parameter - another name for the same memory location.
* Two different expressions that have the same lvalue (memory location) are *aliases* of each other
### 18.7 By Macro Expansion
* Example in C: `#define MIN(X,Y) ((X) < (Y) > (X) : (Y))`. Call with `a = MIN(b,c)`
* Although macros look and sometimes work like methods, they are not methods. Before a program is run or compiled, a pre-processing step replaces each use of the macro with a complete copy of the macro body, with the actual parameters substituted for the formal parameters.
* *Capture*: in any program fragment, an occurence of a variable that is not statically bound within the fragment is *free*.
* For passing parameters by macro expansion, the body of the macro is evaluated in the caller's context. Each actual parameter is evaluated on every use of the corresponding formal parameter, in the context of that occurence of the formal parameter (which is itself in the caller's context)
### 18.8 By Name
* For passing parameters by name, each actual parameter is evaluated in the caller's context, on every use of the corresponding formal parameter.
### 18.9 By Need
* Passing parameters by need means that each actual parameter is evalueated in the caller's context, on the first use of the corresponding formal parameter. The value of the actual parameter is then cached, so that subsequent uses of the formal parameter do not cause reevaluation
### 18.10 Specification Issues
* Are actual parameters always evaluated (eager evaluation) or evaluated only if the corresponding formal parameter is actually used (lazy evaluation)? ML uses eager evaluation.
## Chapter 19: A First Look at Prolog
### 19.2 Prolog Terms
* Constant = *atom*
* Any name beginning with an uppercase letter or an underscore = *variable*
* Atom followed by a parenthesized, comma-separated list of terms = *compound term*
* Pattern matching using Prolog terms is called *unification*
  * Terms are said to unify if there is some way of binding their variables that makes them identical
* Prolog language maintains a collection of facts and rules of inference. A prolog program is just a set of data. The simplest piece of data is a fact, which is a term followed by a period. Here is a prolog program of six facts:
```
parent(kim,holly).
parent(marge,kim).
parent(marge,kent).
parent(esther,marge).
parent(herb,marge).
parent(herb,jean).
```
### 19.3 Getting Started with a Prolog Language System
* Suppose the set of facts is stored in a file called relations. To load the data, do `consult(relations).`
* Now, you can check what is true: `parent(marge,kent)` returns `true.`
* You can also use a variable to get the system to find values that satisfy your query. For example, we use the variable `P` in `parent(P,jean)`, which returns `P = herb.`
* Is someone their own parent? `parent(P, P).` returns `false.`
* Commas are treated as a logical conjunction. Asking `parent(marge,X), parent(X,holly).` returns `X = kim.`
### 19.4 Rules
```
greatgrandparent(GGP,GGC) :-
  parent(GGP, GP), parent(GP, P), parent(P, GGC).
```
* The *head* of the rule is followed by the `:-` token, followed by a comma-separated list of conditions of the rule, followed by a period.
* Rules can be recursive:
```
ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :-
  parent(Z,Y),
  ancestor(X,Z).
```
### 19.5 The Two Faces of Prolog
* Prolog is a declarative language
* Automatic programming: the idea that computers automatically write their own problems, given a description of the problem to be solved
### 19.7 Operators
* `=` takes two parameters and is provable iff the predicates can be unified
* Asking: `=(parent(adam,seth),parent(adam,X)).` returns `X = seth.`
* The arithmetic operators have the usual precedence and associativity; `X = 1+2*3` is shorthand for the term `X = +(1,*(2,3))`. Asking either of these returns `X = 1+2*3`
### 19.8 Lists
* `[]` atom represents empty list
* `.` predicate in prolog corresponds to `::` in ML
* `1::[]` in ML is the same as `.(1,[])` in Prolog
* `[1,2,3]` is the same as `.(1,.(2,.(3,[])))`
* `|` denotes the tail of the list: `[1,2|X]` is the same as `.(1,.(2,X))`
* `append(X,Y,Z)` takes three arguments: two lists to append, and the resulting list
* `member(X,Y)` is provable if list `Y` contains element `X`
* `select(X,Y,Z)` is provable if `Y` contains `X` and `Z` is the same as `Y` but with one instance of `X` removed
* `nth0(X,Y,Z)` is provable if `X` is an integer, `Y` is a list, and `A` is the `X`th element of the list, indexed from 0
* `length(X,Y)` provable if `X` is a list of length `Y`
#### The Anonymous Variable
* Each occurence of `_` is bound independently of any other; put it where you need a variable that is never used
### 19.9 Negation and Failure
* `not` keyword is the logical negation; it returns true if the predicate is false
## Chapter 20: A Second Look at Prolog
### 20.2 Unification
* Unification: pattern-matching technique
* A substitution is a set of bindings for variables
* MGU (most general unifier): Prolog wants to bind variables only when necessary to prove the query
### 20.3 A Procedural View
* `p :- q, r.` can be thought of a procedure; to prove a goal, unify it with `p`, then prove `q`, then prove `r`.
### 20.4 An Implementational View
* The basic step the interpreter uses is *resolution*; it applies one clause from a program to make one step of progress on a list of goal terms to be proved
### 20.5 An Abstract View: Proof Trees
* A proof tree is defines as follows
  * Two types of nodes, nothing nodes and solve nodes
  * Each nothing node has no children
  * Each solve node contains a list of terms. If the list is empty, the solve node is a leaf. Otherwise, the solve node has one child for each clause in the program, in order. If a given clause does not unify with the head of the list at that solve node, the corresponding child is a nothing node. Otherwise, the corresponding child is a solve node containing the list of terms formed from the current list of terms and the clause by applying the resolution step
  * The root of the tree is a solve node containing the list of query terms
### 20.6 The Lighter Side of Prolog
#### Quoted Atoms as Strings
* Any string encolsed in single quotes is a term in Prolog, like `Hello world` or `hello world`
#### `assert` and `retract`
* `assert(X)` adds the term X as a fact in the database, like `assert(green(light))`. `retract` does the opposite
