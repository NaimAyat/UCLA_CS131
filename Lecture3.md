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
  * Ambiguous grammars
    ```
    E -> E + E
    E -> E * E
    E -> ID
    E -> NUM
    E -> (E)
    ```
      * A terminal sandwiched between nonterminals indicates trouble (ex. `E + E` or `E * E`)
      
