# Lab 3 (Jan 26, 2018)
## Summary of Terms
* Phrase/Fragment = list of terminal symbols
* Derivation = a list of rules that describe how to get a phrase from the start rule
* Prefix = `[]`, `[1]`, `[1;2]`, `[1;2;3]` are prefixes of `[1;2;3]`
* Suffix = `[3]`, `[1]`, `[1;2]`, `[1;2;3]` are suffixes of `[1;2;3]`
## Fragment Matcher
```
let make_nucleotide_matcher nucleotide fragment acceptor = match fragment
| [] -> None
| x::xs -> if x = nucleotide then acceptor xs else None

let rec make_fragment_matcher frag fragment acceptor = match frag with 
| [] -> acceptor fragment
| x::xs -> (match fragment with
  | [] -> None
  | n::ns -> let result = make_nucleotide_matcher x [n] accept_empty in 
    match result with
    | Some _ -> make_fragment_matcher xs ns acceptor
    | None -> None)
  
(make_nucleotide_matcher A)
```
