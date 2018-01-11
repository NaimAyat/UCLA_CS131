# Lecture 2 - Jan 11, 2018
## Language Design Issues
* Orthogonality
* Efficiency
* Simplicity
  * Compiletime vs. runtime
* Convenience
  * Ex. `i=i+1` is the same as `i++` in C
* Exceptions
  * Errors/failures, unusual cases
* Concurrency
  * Work well with programs running in parallel
* Mutability
  * Successful languages evolve
    * Ex. C++ is evolving (C++ 17)
    * Syntax changes
  * Ex. C circa 1975:
    * 4 nanoseconds to add integers
    * 16 KiB RAM
    * 1.2 nanoseconds memory cycle time
    * Accessing memory is fast; addition, subtraction, multiplication and division are slow
    * Pointer dereferencing was relatively fast `*p`. Language syntax was designed to reflect speed.
    * Ex. Now, `a[i]` is preferred over `*(a+i)`
