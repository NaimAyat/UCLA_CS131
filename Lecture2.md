# Lecture 2 (Jan 11, 2018)
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
    ```
    obj args[7];
    args[0] = [a];
    args[6] = [g];
    foo (7, args);
    ```
  * C code now: 
    ```
    #define CALLN(...) 
      CALLN(foo,a,...,g);
    ```
  * Steven Bourne (creator of Bourne shell)
    * Wrote Bourne shell in C. Ex. `#define FI }`
  * Syntax
    * Rules + Parser
      * Spoken language is different; "form independent of meaning"
        * "Colorless green ideas sleep furiously." - N. Chomsky
          * Syntactically correct, but meaningless
        * "Ireland has leprechauns galore." - P. Eggert
          * Syntactically incorrect, but meaning is understood
        * "Time flies."
          * Syntactically and semantically correct. 
          * "Time" could be a noun or verb, "flies" is then either a verb or noun, respectively.
          * Ambiguity like this cannot exist in programming languages. The compiler cannot have multiple ways to interepret the same statement.
    * Syntax issues
      * Simplicity
      * Familiarity. It's what people already know, like the statement `a+b/c`
      * Readability
        * Simplicity and readability are sometimes mutually exclusive. Ex. Reverse Polish Notation.
      * Writability
        * Ex. APL accepts non-standard keyboard characters to represent useful mathematical functions.
        * It may be difficult to write concise code that is also readable.
      * Redundancy
        * Ex. Closing parentheses in mathematical expressions are redundant, but useful for readability and error detection.
      * Ambiguity
        * Ex. Does `a-b-c` mean `(a-b)-c` or `a-(b-c)'
          * Note that addition is associative in mathematics, but not in programming. Ex. Floating point addition rounds numbers, so order of addition can affect result.
## Tokens
  * Basic building blocks of most programming languages
  ```
  #include <stdio.h>
  int main(void) {
    return !getchar(); }
  ```
  * In the code block above: `include`, `int`, `main`, `(`, `void`, `)`, `{`, `return`, `!`, `getchar`, `(`, `)`, `;`, `}`, are all tokens.
  * We have a scanner (lexer) that represents each token as a number. 
  * Whitespace (not part of tokens in C; space, newline, return, tab, vertical tab)
  * Comments are not part of tokens
