# Lecture 4 (Jan 18, 2018)
## Syntax
* Grammars
  * BNF
    ```
    xs -> x xs
    xs -> ...
    ```
  * EBNF
    ```
    x*
    ```
  * Syntax diagrams
* Grammars lead to generator, recognizers/parsers
* Finite state machine + stack = push-down automaton
* [Some grammars don't need a stack](Images/stacklessGrammar.jpg)
  * AKA: regular expressions
    * A finite state machine is enough
### Example: Scheme Syntax for Conditional Expression
* EBNF example:
```
<cond> -> (cond <cond clause>+)
          | (cond <cond clause>* (else <sequence>))
```
* [Syntax diagram equivalent of above example](Images/syntaxDiagram.jpg)
* Parser example:
  ```
  parse_cond() {
    scan_for("(");
    scan_for("cond");
    if (lookahead(["(";"else"])) {
        scan_for("("; scan_for("else");
        parse_sequence();
        scan_for(")")'
    }
    else
      while(...)
    }
  ```
#### Homework 2 Outline
* Write a function where:
  * Input is a grammar
  * Output is another function that is a parser
    * Input to parser is another token sequence
    * Parser outputs whether token sequence is part of grammar
* Three key features:
  1. Recursion
  2. Alternation (OR)
  3. Concatenation (easy for finite state machines)
### Expressions and their Problems
* Handled by grammars:
  * Precedence
  * Associativity
    * Prolog lets you define your own operators
## Functional Programming
* Motivations
  1. Clarity
     * Centuries of experience; taught to children
     * Ex: `i = i+1` is false in mathematics
  2. Performance
     * Escame from von Neumann bottleneck
 * Function
   * Mapping from a domain to a range
 * Functional forms
   * Function where domain or range includes functions
   * Ex. `SIGMA(plus, 0, 100)`
   * No assignment statements
   * No side effects
