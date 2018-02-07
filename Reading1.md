# *Modern Programming Languages, 2nd Edition* (Webber)
# Chapters 1 - 11
## Chapter 1
### 1.2 Variety
* Imperative language: supports assignment and iteration (ex. C)
* Functional language: supports recursion and single-valued variables (ex. ML, Lisp)
  * Recursion is as natural in ML as iteration is in C
* Logic language: programs written in terms of rules about logical inference (ex. Prolog)
  * Not well-suited for computing mathematical functions
* Object-oriented language: in addition to being imperative, it is easier to define objects (ex. C++, Java)
* Multi-paradigm languages: attempt to combine features of multiple language types (ex. JavaScript, OCaml, Python)
### 1.3 Controversies
* The definition of *object-oriented* is heavily debated; some languages may be considered more object-oriented than others
### 1.4 Evolution
* Good languages can evolve new dialects (ex. Fortran II through Fortran 2008)
### 1.5 Connections
* It is best to adapt programming style to the language in use (ex. write many small functions in ML, use objects in Java)
## Chapter 2
### 2.1 Introduction
* Syntax - defines program form and structure
* Semantics - defines what programs do; their behavior and meaning
### 2.2 A Grammar Example for English
* We use the symbol `<A>` for article and express our definition:
```
<A> ::= a | the
```
* Similarly, the words `dog`, `cat` are nouns:
```
<N> ::= dog | cat | rat
```
* A noun phrase is an article followed by a noun:
```
<NP> ::= <A> <N>
```
* Now, we define verbs:
```
<V> ::= loves | hates | eats
```
* A sentence is a noun phrase, followed by a verb, followed by another noun phrase:
```
<S> ::= <NP> <V> <NP>
```
* Combining these definitions, we have a grammar that defines a small subset of unpunctuated English.
```
<S> ::= <NP> <V> <NP>
<NP> ::= <A> <N>
<A> ::= a | the
<N> ::= dog | cat | rat
<V> ::= loves | hates | eats
```
#### Parse Trees
* Think of the grammar as a set of rules that say how to build a tree. `<S>` is the root, and the grammar tells how children can be added at any point (node) on the tree.
* [Example parse tree from the example above](Images/parseTree.PNG)
### 2.3 A Grammar Example for a Programming Language
* Here is an example of a grammar for a simple language of expressions with three variables:
```
<exp> ::= <exp> + <exp> | <exp> * <exp> | ( <exp> ) | a | b | c
```
* [Here is a parse tree for the expression `((a + b) * c)`](Images/parseTree2.PNG)
  * Unlike the example of English grammar; this defines an infinite language. Expressions can be arbitrarily long. It is arecursive grammar; an `<exp>` node can occur as the descendant of another `<exp>` node in the parse tree
* Finding a parse tree for a given string is called *parsing* the string
### 2.4 Definition of Grammars: Backus-Naur Form
* A grammar has four main components:
  1. Tokens
     * The smallest units of syntax. They are the strings and symbols that we choose not to think of as consisting of smaller parts. (ex. `if`, `!=`)
  2. Non-terminal symbols
     * Strings enclosed in `<>` (ex. statements and expressions)
  3. Productions
     * The left-hand side, the separator `::=`, and a right-hand side. The left side is a single non-terminal symbol; the right side is a sequence of one or more things, each of which can either be a token or a non-terminal symbol.
     * Give one possible way of building a parse tree; permits the non0terminal symbol on the left-hand side to have the symbols on the right-hand side, in order, as its children in a parse tree
  4. Start symbol (non-terminal)
     * Non-terminal symbol designated by the grammar. This is the root of the parse tree.
  * In our English example, the start symbol is `<S>`; production is `<NP>`; non-terminal symbols are `<V>`, `<N>`, `<A>`; tokens are `loves`, `hates`, `eats`, `dog`, `cat`, `rat`, `a`, `the`
  * The special non-terminal symbol `empty` is sometimes used where the grammar needs to generate an empty string, a string of no tokens. For instance, an `if-then` statement with an optional else might be defined like this:
  ```
  <if-stmt> ::= if <expr> then <stmt> <else-part>
  <else-part> ::= else <stmt> | <empty>
  ```
### 2.5 Writing Grammars
* Divide and conquer
* BNF example for Java subset
  ```
  <var-dec> ::= <type-name> <declarator-list> ;
  <type-name> ::= boolean | byte | short | int | long | char | float | double
  <declarator-list> ::= <declarator> | <declarator> , <declarator-list>
  <declarator> ::= <variable-name> | <variable-name> = <expr>
  ```
### 2.6 Lexical Structure and Phrase Structure
* *Fixed-format* lexical structure - some columns in each line have special significance
  * Archaic (original Fortran, Cobol, Basic)
* *Free-format* lexical structure - columns have no significance
  * Modern (Java, C)
  * Could theoretically write every program in a single line
* Some languages are a mixture of fixed- and free-format (ex. Python)
### 2.7 Other Grammar Forms
* BNF (Backus-Naur Form) variations
  * `=` or `->` can be used in place of `::=`
  * *Metasymbols* are part of the language of the definition, not the language being defined (ex. `<`, `>`, `|`, or `::=`)
* EBNF (Extened BNF) adds `[`, `]`, `{`, `}`, `(`, `)`
  * `[something]` in the right-hand side of a production means that the `something` inside is optional
  * `{something}` in the right-hand side of a production means that the `something` can be repeated zero or more times
  * Parentheses group things on the RHS so that `|`, `[]`, and `{}` can be used unambiguously
  * Example: an  `if-then` statement with an optional else: `<if-stmt> ::= if <expr> then <stmt> [else <stmt>]`
  * Example: zero or more statements, each ending with a semicolon: `<stmt-list> ::= {<stmt> ;}`
  * Example: a list of zero or more things, each of which can be either a statement or declaration and each ending with a semicolon: `<thing-list> ::= { (<stmt> | <declaration>) ; }`
  * Recall that parentheses are metasymbols, they make it clear that the `;` token is not part of the choice permitted by the `|` metasymbol (which is the logical "or").
  * If we want to use a metasymbol as a token, we place it in single quotes. For example: `<arr> ::= 'a[1]'` defines the language containing just the string `a[1]`.
## Chapter 3
### 3.2 Operators
* *Unary* operators take a single operand; for instance, the ML language uses the token `~` as the unary negation operator, so the expression `~a` yields the negation of the operand `a`. 
* *Binary* operators take two operands; for instance, the `+` token takes in the operands `a` and `b`for `a+b`
* *Ternary* operators take three operands; for instance, the java expression `a?b:c` has the value of either `b` or `c` depending on whether `a` is `true` or `false`.
* *Infix notation*: binary operators are written between their operands, like `a+b`
* *Prefix notation*: binary operators are written before their operands, like `+ a b`
* *Postfix notation*: binary operators are written after their operands, like `a b +`
* Unary operators, of course, can only be either prefix or postfix.
### 3.3 Precedence
* Consider the following grammar:
  ```
  <exp> ::= <exp> + <exp>
          | <exp> * <exp>
          | ( <exp> )
          | a | b | c
  ```
  * This is syntactically correct, however, it is ambiguous. Consider the operation `a+b*c`. The grammar can generate two different parse trees; one for `a+(b*c)` and one for `(a+b)*c`.
  * Assuming we want `a+b*c` to signify `a+(b*c)`, we modify the grammar:
    ```
    <exp> ::= <exp> + <exp> | <mulexp>
    <mulexp> ::= <mulexp> * <mulexp>
               | ( <exp> )
               | a | b | c
    ```
    * This language has only two levels of precedence: multiplication at the higher level and addition at the lower level. If we wanted to add an exponentiation operator, we modify the grammar:
      ```
      <exp> ::= <exp> + <exp> | <mulexp>
      <mulexp> ::= <mulexp> * <mulexp> | <powerexp>
      <powerexp> ::= <powerexp> ** <powerexp> 
                   | ( <exp> )
                   | a | b | c
      ```
    * Note that we define noneterminal symbols in order from lowest to highest precedence: `<exp>`, `<mulexp>`, `<powerexp>`
### 3.4 Associativity
* The grammar for a language must generate only one parse tree per expression. In most languages, `a+b+c` specifies `(a+b)+c`. Hence, the `+` operator is *left associative*. 
* For a left associative grammar, we do:
  ```
  <exp> ::= <exp> + <mulexp> | <mulexp>
  <mulex> ::= <mulexp> * <rootexp> | <rootexp>
  <rootexp> ::= ( <exp> )
              | a | b | c
  ```
### 3.5 Other Ambiguities
* Dangling `else` problem: does `if e1 then if e2 then s1 else s2` mean `if e1 then (if e2 then s1) else s2` or `if e1 then (if e2 then s1 else s2)`?
  * Most languages do the latter - an `else` always goes with its nearest unmatched `if`
    * To accomplish this:
      ```
      <stmt> ::= <if-stmt> | s1 | s2
      <if-stmt> ::= if <expr> then <full-stmt> else <stmt>
                  | if <expr> then <stmt>
      <expr> ::= e1 | e2
      ```
### 3.7 Parse Trees and EBNF
* EBNF can make grammar definitions more clearly. For example, `<exp> ::= <exp> + <mulexp> | <mulexp>` is more clearly written as `<exp> ::= <mulexp> {+ <mulexp>}`.
* Example: EBNF left-justified grammar defining addition and multiplication:
  ```
  <exp> ::= <mulexp> {+ <mulexp>}
  <mulexp> ::= <rootexp> {* <rootexp>}
  <rootexp> ::= `(` <exp> `)`
              | a | b | c
  ```
  * Notice that we now have to quote parentheses
## Chapter 4
### 4.2 The Classical Sequence
* *Integrated development environment (IDE)*: language system that provides the programmer a single interface for editing, running, and debugging programs. 
* Hardware does not understand source files. They must be first processed by a compiler, which translates programs into assembly.
  * Each line in assembly represents either a piece of data or an instruction for the processor. 
    * An assembler processes the assembly to convert each instruction into the machine's binary format, its *machine language*. The resulting *object file* is no longer readable by people.
    * Next, a *linker* combines all the different components of the program. The linker's output is stored in a single *executable* file. This still may not be completely in machine language. Each time the user runs the executable, the system *loader* gets the program into memory and adds finishing touches.
#### Optimization
* Compilers usually optimize code automatically. For example,
  ```
  int i = 0;
  while (i < 100) {
    a[i++] = x*x*x;
  }
  ```
  Gets a *loop invariant removal* optimization, since we don't need to recompute `x*x*x*` each iteration of the loop:
  ```
  int i = 0;
  int temp = x*x*x;
  while (i < 100) {
    a[i++] = temp
  }
  ```
### 4.3 Variations on the Classical Sequence
* Interpreters carry out programs without needing it to translate it to machine language. Hence, interpreted code runs much slower than compiled code.
* Almost every web browser has an interpreter for the Java virtual machine. When you visit a Web page that contains a Java applet, the applet is a Java *bytecode* file, a file in the machine-language format of the Java virtual machine. The browser runs the applet by interpreting its bytecode.
### 4.4 Binding Times
* *Binding*: associating properties with names
#### Language-Definition Time
Some properties are bound when the language is defined. In C, for example, the meaning of the keywords `void` and `for` are part of the language definition.
#### Language-Implementation Time
Some properties are left out of the language definition, either intentionally or accidentally, and are up to each implementation of the language. In C, the range of values for `int` depends on what the compiler determines to be most natural on the machine. Same in ML. In Java, the range of `int` is bound at language-definition time as 32-bits.
#### Compile Time
Many properties are determined by the compiler. In statically typed languages like C, the types of all variables are boind at compile time. 
#### Link Time
The linker finds the definitions of library functions to match each reference in a program.
#### Load Time
The loader puts finishing touches on a program before it begins to run each time. Memory addresses are bound at load time.
#### Runtime
Most binds happen when the program runs - for example, the value of an iterator variable `i` is bound during runtime.
### 4.5 Debuggers
* When the program hits a fatal defect, the debugger makes a *core dump*, writing a copy of its memory to a file. A language-system tool later extracts useful information from the dump file: the point where the problem occured, the *traceback* of function calls leading up to that point, the values of variables at that point, etc.
### 4.6 Runtime Support
* If a program makes explicit calls to library functions, the linker is expected to include that code in the executable. Some additional code is usually included if the program does not refer to it explicitly. This *runtime support* code is important for:
  * Startup processing. The first thing that runs is the runtime support code, which sets up the processor and memory the way the high-level code expects.
  * Exception handling. What should the program do if something goes wrong, (ex. divide by 0)? 
  * Memory management. Some languages implicitly require extensive management. Whenever an entity is created/deleted, memory must be allocated/reused/cleared.
  * OS interface. Most programs communicate with the OS about things like keyboard and mouse input. This may require some special structure provided by runtime support.
  * Concurrent execution. Some languages, like Java, include support for multi-threadded programs. Interthread communication and synchronization, as well as thread creation/destruction, require runtime support.
## Chapter 5
