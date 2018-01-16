# Lecture 3 (Jan 16, 2018)
## Grammars
* Grammars are descriptions of languages
  * Used to generate sentences
  * Used to parse sentences
* Grammars are (almost) programs
* What can go wrong with grammars?
  * Nonterminal used but not defined (useless rule)
  * Nonterminal defined but not used (useless nonterminal)
  * Nonterminal not reachable from start symbol
  * Nonterminals that can never produce a string of terminals
  * Trying to use grammar to capture constraints that are best captured elsewhere
  * 1 token = 1 character
    * Using grammars to specify details best handled by technology
  * Ambiguous grammars ([example](Images/ambiguous.jpg))
    ```
    E -> E + E
    E -> E * E
    E -> ID
    E -> NUM
    E -> (E)
    ```
      * A terminal sandwiched between nonterminals indicates trouble (ex. `E + E` or `E * E`)
      
* Discover and Fix Ambiguity
  * Prove that a single string can produce two or more parses
  * Rewrite grammar to have associativity constraints (ex. left-associative operator)
  * Rewrite grammar to have precedence tules (ex. multiplication before addition)
* Multiple Notations for Grammars
  * BNF (Backus–Naur form)
  * EBNF (Extended BNF)
    * Recall
      * `x*` zero or more `x`s in a sequence
      * `x+` one or more `x`s in a row
    * Used for RFC 5322 (Internet message format). Where `/` represents `OR` and specials are `()<>@;:\'"[]`:
    ```
    msg-id = "<" word *("."word) "@" atom* ("." atom) ">"
    ```
    ```
    word = atom / quoted-string
    atom = 1*<any CHAR except specials, SPACE, and CTLs>
    quoted-string = <"> *(qtext / quoted-pair) <">
    qtext = <any CHAR except " \ CR> 
    quoted=pair = "\" CHAR
    ```
