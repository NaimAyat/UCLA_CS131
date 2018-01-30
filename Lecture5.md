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
    char buf[100]'
    void *p = buf;
    int *ip = p;
    p[0] = 27;
    ```
* Type equivalence
  * Structural equivalence: types are the same if their layout or operations are the same
    * Layout: applies to exposed-type languages
    * Operations: applies to languages with information hiding
  * Basically, given two types, T<sub>1</sub> and T<sub>2</sub>, is T<sub>1</sub> ≡ T<sub>2</sub>?
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
  * Given two types, T<sub>1</sub> and T<sub>2</sub>, is T<sub>1</sub> a subset of T<sub>2</sub>?
  * `int` is a subset of `long` in C
  * `char*` is a subset of `char const*`


## Java

## Parallelism
