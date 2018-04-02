(* subset tests *)
let my_subset_test0 = subset [] []
let my_subset_test1 = subset [] [1;900;2]
let my_subset_test2 = subset [1;1;1;2] [2;1;2]
let my_subset_test3 = not (subset [3;1] [1;2])

(* equal_sets tests *)
let my_equal_sets_test0 = equal_sets [3;9] [3;9;3;3]
let my_equal_sets_test1 = not (equal_sets [1;2;3] [1;1;3])
let my_equal_sets_test2 = equal_sets [] []
let my_equal_sets_test3 = equal_sets [3;9;3;3] [3;9]

(* set_union tests *)
let my_set_union_test0 = equal_sets (set_union [1] []) [1]
let my_set_union_test1 = equal_sets (set_union [3;1;4;3;3;3;4] [1;2;3;4]) 
                         [1;2;3;4]
let my_set_union_test2 = equal_sets (set_union [] []) []
let my_set_union_test3 = equal_sets (set_union [] [1]) [1]

(* set_intersection tests *)
let my_set_intersection_test0 = equal_sets (set_intersection [] [1]) []
let my_set_intersection_test1 = equal_sets 
                                (set_intersection [1;1;1;1;3;4] [1;9]) [1]
let my_set_intersection_test2 = equal_sets (set_intersection [1;2;3;4] 
                                [4;2;1;3]) [1;2;3;4]
let my_set_intersection_test3 = equal_sets (set_intersection [1] [5]) []

(* set_diff tests *)
let my_set_diff_test0 = equal_sets (set_diff [1;4] [1;2;3;4]) []
let my_set_diff_test1 = equal_sets (set_diff [1;1;1;1;1] [1]) []
let my_set_diff_test2 = equal_sets (set_diff [1;2;3;4] []) [1;2;3;4]
let my_set_diff_test3 = equal_sets (set_diff [] [1]) []
let my_set_diff_test4 = equal_sets (set_diff [1;2;3;4] [3;2]) [1;4]

(* computed_fixed_point tests *)
let my_computed_fixed_point_test0 = computed_fixed_point (=) 
                                    (fun x -> x / 10) 9000000000000000 = 0;;
let my_computed_fixed_point_test1 = computed_fixed_point (=) (fun y -> y) 
                                    100000000 = 100000000
let my_computed_fixed_point_test2 = computed_fixed_point (=) (fun z -> 1) 2 = 1

(* computed_periodic_point tests *)
let my_computed_periodic_point_test0 = computed_periodic_point (=) 
                                       (fun x -> -x) 2 (-2) = -2
let my_computed_periodic_point_test1 = computed_periodic_point (=) 
                                       (fun x -> x) 1 1 = 1
let my_computed_periodic_point_test2 = computed_periodic_point (=) 
                                       (fun x -> x) 0 0 = 0

(* while_away tests *)
let my_while_away_test0 = while_away ((+) 4) ((>=) 13) 1 = [1; 5; 9; 13]
let my_while_away_test1 = while_away ((-) 5) ((<) 0) 9 = [9]
let my_while_away_test2 = while_away (fun x -> x * 3) (fun y -> y < 100) 1 =
                          [1; 3; 9; 27; 81]

(* rle_decode tests *)
let my_rle_decode_test0 = rle_decode [1, "t"; 2, "e"; 3, "s"; 4, "t"] = 
                          ["t"; "e"; "e"; "s"; "s"; "s"; "t"; "t"; "t"; "t"]
let my_rle_decode_test1 = rle_decode [1, "t"; 2, "e"; 0, "m"; 3, "s"; 4, "t"] = 
                          ["t"; "e"; "e"; "s"; "s"; "s"; "t"; "t"; "t"; "t"]
let my_rle_decode_test2 = rle_decode [0, "t"; 0, "e"; 0, "m"; 0, "s"; 0, "t"] =
                          []

(* filter_blind_alleys tests *)
type nonterminals = | Alpha | Beta | Charlie | Delta | Epsilon
let r0 =
    [Alpha, [T""; N Beta; T "test"];
    Beta, [N Alpha];
    Epsilon, [T"test"]]

let g0 = Alpha, r0
let my_filter_blind_alleys_test0 = filter_blind_alleys g0 =
                                   (Alpha, [Epsilon, [T"test"]])

let r1 = 
    [Alpha, [N Beta];
    Beta, [N Charlie];
    Charlie, [N Delta];
    Delta, [N Epsilon];
    Epsilon, [T"1"]]

let g1 = Alpha, r1
let my_filter_blind_alleys_test1 = filter_blind_alleys g1 = g1
