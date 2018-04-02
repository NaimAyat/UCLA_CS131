type ('nonterminal, 'terminal) symbol =
    | N of 'nonterminal
    | T of 'terminal

(* returns a Homework 2-style grammar, which is converted from the 
 * Homework 1-style grammar gram1.
 * *)
let convert_grammar gram1 =
    let rec switch nonterminal1 rules = match rules with
        | [] -> []
        | (nonterminal2, srhs)::xs -> if (nonterminal1 = nonterminal2) 
          then (srhs::(switch nonterminal1 xs)) 
          else switch nonterminal1 xs in ((fst gram1), 
          fun nonterminal1 -> (switch nonterminal1 (snd gram1)));;

(* Finds the leftmost derivation corresponding to a matching prefix; which, in 
 * turn, corresponds to a nonterminal symbol of the grammar.
 * *)
let rec derive_phrase rules right accept d frag = 
    if (right = []) 
    then (accept d frag)
    else match frag with 
        | [] -> None
        | x::xs -> match right with
            | [] -> None
            | (T t)::srhs -> if x = t 
                then (derive_phrase rules srhs accept d xs) 
                else (None)
            | (N n)::srhs -> (matcher rules n (derive_phrase rules srhs accept)
                              d frag)
                (* Finds a prefix corresponding to a nonterminal symbol of
                 * the grammar.
                 * *)
                and get_node rules start rhs accept d 
                frag = match rhs with 
	        | [] -> None
	        | x::xs -> match (derive_phrase rules x accept 
                    (d @ [(start, x)]) frag) with 
	            | Some (a, b) -> Some (a, b)
		    | None -> get_node rules start xs 
                        accept d frag and 
                        (* Compares the result of derive_phrase to an 
                         * arbitrary two-tuple to yield a fragment.
                         * *)
                        matcher rules start accept d frag = 
                        get_node rules start (rules start) accept d frag
       
let parse_prefix gram accept frag = match gram with 
    | (start, rules) -> matcher rules start accept [] frag;;