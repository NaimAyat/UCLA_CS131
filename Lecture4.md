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
* [Syntax diagram equivalent of above grammar](Images/syntaxDiagram.jpg)
