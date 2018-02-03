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
