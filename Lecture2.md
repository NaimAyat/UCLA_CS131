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
  * GE 225 (1960s computer)
    * 40 nanoseconds to add int
    * 500 nanoseconds to divide int
    * 40 KiB RAM
    * Running BASIC
    * "The programs we are writing now will be completely obsolete by the time your careers are over."
    * "Good languages, therefore, must be able to evolve."
      * Ex. Simula 67 (language) failed to evolve
  * C code from last year:
    `obj args[7];
    args[0] = [a];
    args[6] = [g];
    foo (7, args);`
  * C code now: `#define CALLN(...) CALLN(foo,a,...,g);`
