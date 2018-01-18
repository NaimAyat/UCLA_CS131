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
* [Some grammars don't need a stack](stacklessGrammar.jpg)
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

