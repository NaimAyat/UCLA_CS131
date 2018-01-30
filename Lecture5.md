# Lecture 5 (Jan 30, 2018)
## Types
* Roles:
  * Annotation
    * For programmers
    * For compilers
  * Inference
    * Can infer types from other information
* Time: 
  * Dynamic vs. static time-checking
    * Dynamic = more flexible, simpler in practice
    * Static = more reliable
* Strongly-typed languages: you cannot escape type checking
  * Ex. OCaml is strongly typed. C is not; you can subvert type checking with pointers.
    ```
    char buf[100];
    void *p = buf;
    int *ip = p;
    p[0] = 27;
    ```
* Type equivalence
  * Structural equivalence: types are the same if their layout or operations are the same
    * Layout: applies to exposed-type languages
    * Operations: applies to languages with information hiding
  * Basically, given two types, T<sub>1</sub> and T<sub>2</sub>; is T<sub>1</sub> ≡ T<sub>2</sub>?
    ```
    struct s {int val; struct t*next;};
    struct t {int val; struct s*next;};
    
    struct s a;
    struct t b;
    
    ...
    
    a = b;
    ```
  * Name equivalence: must have same names
* Subtypes
  * Ex. Subclasses in C++ or Java
  * Given two types, T<sub>1</sub> and T<sub>2</sub>; is T<sub>1</sub> ⊆ T<sub>2</sub>?
  * `int` is a subtype of `long` in C
  * `char*` is not a subtype of `char const*`
    * Can do both loads and stores on `char*`; can only do loads on `char const*`
    * Inverse is true: `char const*` ⊆ `char*`
### Polymorphism
* Ex. `sin(x)`
  * In Fortran (polymorphic): 
    * One `sin` function, `sin(x)`, depends on type of argument; float, double, or long double
    * Implementation identified by looking at arguments
  * In C (not polymorphic):
    * There are different `sin` functions for each argument type: `sin`, `sinf`, etc.
#### "Ad-Hoc" Polymorphism ("Hack-y")
* Overloading: identify implementation by looking at argument types or result type
  * Ex. `double x = sin(10);`
    * `x` is a double; `sin` is an int
  * Implemented on a nonoverloaded system by *name manging*
    * Flat symbol table
* Coercion: coversion of a value to a different data type
  ```
  double x, y;
  x = 3;            // implicit coercion (coercion)
  y = (double) 5;   // explicit coercion (casting)
  ```
#### Universal Polymorphism
* Infinite number of types, specified by programmer
#### Parametric Polymorphism
* A function type contains a type variable. Ex. `length: 'a list -> int`

## Java

## Parallelism
