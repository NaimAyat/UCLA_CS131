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
### Example: Scheme Syntax for Conditional Expression
* EBNF
```
<cond> -> (cond <cond clause>+)
          | (cond <cond clause>* (else <sequence>))
```
* [Syntax diagram equivalent of above example](Images/syntaxDiagram.jpg)
* Grammars lead to generator, recognizers/parsers
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
* Finite state machine + stack = push-down automaton

