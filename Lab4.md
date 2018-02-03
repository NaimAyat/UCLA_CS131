# Lab 4 (Feb 2, 2018)
## Midterm
* Open book, open notes
  * Bring homework, notes from class, sections
  * Textbook
* Review all material on syllabus table
* Question types
  * Short answer (yes/no and why)
  * Coding
## Java Memory Model
* All objects are references, allocated on the heap
* All objects are passed by value, but most values are objects (which are stored as pointers)
* Concurrency: Correctly and efficiently managing access to shared resources (from multiple possibly-simultaneous clients)
## Java Threads
* Implemented in `Thread` class
* Threads' executions can be interleaved (sequential consitency)
### Synchronized
* `Synchronized` keyword is used to guarantee operations are atomic
* No two threads can run the same function at once
* Using locks, establishes a "happens before" relationship
### Volatile
* `Volatile` keyword describes variable which will be modified b multiple threads
* The value of this variable will never be cached thread-locally: all reads and writes will go straight to main memory
## Midterm Examples
1. Write an OCaml function merge_sorted that merges two sorted lists. Its first argument should be a comparison function `lt` that compares two list elements and returns true if the first element is less than the second. Its second and third arguments should be the lists to be merged. 
    * For example: `(merge_sorted (<) [21; 49; 49; 61] [-5; 20; 25; 49; 50; 100])`
    * Should yield: `[-5; 20; 21; 25; 49; 49; 49; 50; 61; 100]`
    * Answer:
      ```
      let rec merge_sorted lt a b = match a with
      | [] -> b
      | headA::tailA -> (match b with
        | [] -> a
        | headB::tailB -> if lt headA head B
          then headA::(merge_sorted lt tailA b)
          else headB::(merge_sorted lt a tailB))
      ```
2. What is the type of `merge_sorted` from question (1)?
   * Answer: `('a -> 'a -> bool) -> ('a list) -> ('a list) -> ('a list)`
3. What does the following expression yield, and what is its type: 

   `merge_sorted(fun a b -> List.length a < List.length b)`?
   * Answer: `(('a list) -> ('a list) -> (bool))`
   * Answer: `('a list list) -> ('a list list) -> ('a list list)`
