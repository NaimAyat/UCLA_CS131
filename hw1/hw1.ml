(* HELPER FUNCTIONS *)

(* Returns true iff element a is in list b *)
let rec contains a b = match b with
    | [] -> false
    | h::t -> if a = h then true else contains a t;;

(* Helper for computed_periodic_point *)
let rec periodic f p x = match p with
    | 0 -> x
    | _ -> periodic f (p - 1) (f x);;

(* HOMEWORK FUNCTIONS *)

(* Returns true iff a is a subset of b *)
let rec subset a b = match a, b with
    | [], [] -> true
    | _, [] -> false
    | [], _ -> true
    | [a], [b] -> if a <> b then false else true
    | h1::t1, h2::t2 -> if (if h1 = h2 then true else subset [h1] t2)
      then subset t1 b else false;;

(* Returns true iff the represented sets are equal *)
let equal_sets a b = (subset b a && subset a b) || (a = [] && b = []);;

(* Returns a list representing the union of a and b *)
let rec set_union a b = match a with
    | [] -> b
    | h::t -> if (contains h b) then (set_union t b) else set_union t ([h] @ b);;

(* Returns a list representing the intersection of a and b *)
let rec set_intersection a b =
    let result = match a with
    | [] -> []
    | h::t -> if contains h b then h::(set_intersection t b)
      else set_intersection t b in
    List.sort_uniq compare result;;

(* Returns a list representing a-b, set of all members of a that are not in b *)
let rec set_diff a b = match a with
    | [] -> []
    | h::t -> if List.mem h b then set_diff t b else h::(set_diff t b);;

(* Returns the computed periodic point for f with period p, and with respect to
 * x and equality predicate eq
 *)
let rec computed_fixed_point eq f x = if eq x (f x) then x
    else computed_fixed_point eq f (f x);;

(* Returns the computed periodic point for f with period p, with respect to x
 * and equality predicate eq
 *)
let rec computed_periodic_point eq f p x = if eq (periodic f p x) x then x
    else computed_periodic_point eq f p (f x);;

(* Returns the longest list such that p e is true for every list element e *)
let rec while_away s p x = if (p x) then x::while_away s p (s x) else [];;

(* Decodes a list of pairs lp- in run-length encoding form *)
let rec rle_decode lp = match lp with
    | [] -> []
    | (h1, h2)::t -> if h1 = 0
      then rle_decode(t) else h2::rle_decode ((h1-1,h2)::t);;

type ('nonterminal, 'terminal) symbol =
    | N of 'nonterminal
    | T of 'terminal

(* Returns a copy of the grammar g with all blind-alley rules removed *)
let filter_blind_alleys g =
    (* Returns true if symbol is nonterminal *)
    let check_nonterminal symbol rhs = match symbol with
        | T symbol -> true
        | N symbol -> if List.exists (fun x -> (fst x) = symbol) rhs then true
					else false in
    (* Return true if all symbols in RHS exist in terminal *)
    let rec check_rhs a rhs = match a with
        | [] -> true
        | symbol::t -> if (check_nonterminal symbol rhs) then true &&
          (check_rhs t rhs) else false in
    (* Generates RHS *)
    let rec fix_rhs rules rhs = match rules with
        | [] -> rhs
        | h::t -> if (check_rhs (snd h) rhs) && (not (subset [h] rhs))
	  then fix_rhs t (h::rhs) else (fix_rhs t rhs) in
    	(fst g, List.filter (fun x -> List.exists (fun e -> e = x)
	(computed_fixed_point (=) (fix_rhs (snd g)) [])) (snd g));;
