let accept_all derivation string = Some (derivation, string)
let accept_empty_suffix derivation = function
   | [] -> Some (derivation, [])
   | _ -> None

(* Grammar from Homework 1 spec *)
type awksub_nonterminals =
  | Expr | Lvalue | Incrop | Binop | Num

let awksub_rules =
   [Expr, [T"("; N Expr; T")"];
    Expr, [N Num];
    Expr, [N Expr; N Binop; N Expr];
    Expr, [N Lvalue];
    Expr, [N Incrop; N Lvalue];
    Expr, [N Lvalue; N Incrop];
    Lvalue, [T"$"; N Expr];
    Incrop, [T"++"];
    Incrop, [T"--"];
    Binop, [T"+"];
    Binop, [T"-"];
    Num, [T"0"];
    Num, [T"1"];
    Num, [T"2"];
    Num, [T"3"];
    Num, [T"4"];
    Num, [T"5"];
    Num, [T"6"];
    Num, [T"7"];
    Num, [T"8"];
    Num, [T"9"]]

let awksub_grammar = Expr, awksub_rules

(* To test convert_grammar *)
let new_awksub = convert_grammar awksub_grammar;;

let test_1 = (parse_prefix new_awksub accept_all ["(";"(";"("; "0";")";")";")"] = 
             Some ([(Expr, [T "("; N Expr; T ")"]); (Expr, [T "("; N Expr; T ")"]); 
                    (Expr, [T "("; N Expr; T ")"]); (Expr, [N Num]); (Num, [T "0"])], 
                    []));;


type english_nonterminals =
    | S | DP | D | NP | VP | V | PP | P

let english_rules = 
    [ S, [N DP; N VP]; 
      S, [N DP; N VP]; 
      DP, [N D; N NP; N PP]; 
      DP, [N D; N NP];
      DP, [N D];
      D, [T"his"]; 
      D, [T"the"];
      D, [T"He"]; 
      D, [T"She"];
      NP, [T"key"]; 
      NP, [T"keys"]; 
      NP, [T"car"];
      VP, [N V; N DP]; 
      VP, [N V; N DP; N PP];
      V, [T"stopped"]; 
      V, [T"started"];
      PP, [N P; N DP];
      PP, [N P];
      P, [T"with"]; 
      P, [T"via"]]

let english_grammar = S, english_rules

(* To test convert_grammar *)
let new_english = convert_grammar english_grammar;;

let test_2 = ((parse_prefix new_english accept_all 
             ["He"; "started"; "the"; "car"; "with"; "his"; "key"])
           = Some ([(S, [N DP; N VP;]);  (DP, [N D]); (D, [T"He"]);
             (VP, [N V; N DP]); (V, [T"started"]); (DP, [N D; N NP; N PP]);
             (D, [T"the"]); (NP, [T"car"]); (PP, [N P; N DP]); (P, [T"with"]); 
             (DP, [N D; N NP]); (D, [T"his"]); (NP, [T"key"])], []))