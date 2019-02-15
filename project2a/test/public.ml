open OUnit2
open Basics
open TestUtils

let test_dup ctxt =
  assert_equal false (dup 3 4 5) ~msg:"dup (1)" ~printer:string_of_bool;
  assert_equal true (dup 5 2 5) ~msg:"dup (2)" ~printer:string_of_bool;
  assert_equal true (dup 3 3 3) ~msg:"dup (3)" ~printer:string_of_bool;
  assert_equal false (dup 'a' 'b' 'c') ~msg:"dup (4)" ~printer:string_of_bool

let test_head_divisor ctxt =
  assert_equal false (head_divisor []) ~msg:"head_divisor (1)" ~printer:string_of_bool;
  assert_equal false (head_divisor [1]) ~msg:"head_divisor (2)" ~printer:string_of_bool;
  assert_equal true (head_divisor [2; 4; 7]) ~msg:"head_divisor (3)" ~printer:string_of_bool

let test_second_element ctxt =
  assert_equal (-1) (second_element []) ~msg:"second_element (1)" ~printer:string_of_int;
  assert_equal 2 (second_element [4; 2]) ~msg:"second_element (2)" ~printer:string_of_int;
  assert_equal 6 (second_element [4; 6; 9]) ~msg:"second_element (3)" ~printer:string_of_int

let test_max_first_three ctxt =
  assert_equal 7 (max_first_three [7; 4; 7]) ~msg:"max_first_three (1)" ~printer:string_of_int;
  assert_equal 2 (max_first_three [2; 2; 2]) ~msg:"max_first_three (2)" ~printer:string_of_int;
  assert_equal 10 (max_first_three [10; 0; 1]) ~msg:"max_first_three (3)" ~printer:string_of_int;
  assert_equal 3 (max_first_three [3; 2; 0]) ~msg:"max_first_three (4)" ~printer:string_of_int

let test_cubes ctxt =
  assert_equal 100 (cubes 4) ~msg:"cubes (1)" ~printer:string_of_int;
  assert_equal 9 (cubes 2) ~msg:"cubes (2)" ~printer:string_of_int;
  assert_equal 14400 (cubes 15) ~msg:"cubes (3)" ~printer:string_of_int;
  assert_equal 1296 (cubes 8) ~msg:"cubes (4)" ~printer:string_of_int

let test_sum_odd ctxt =
  assert_equal 6 (sum_odd [1; 4; 5]) ~msg:"sum_odd (1)" ~printer:string_of_int;
  assert_equal 0 (sum_odd []) ~msg:"sum_odd (2)" ~printer:string_of_int;
  assert_equal 1 (sum_odd [4; 8; 6; 1]) ~msg:"sum_odd (3)" ~printer:string_of_int

let test_is_even_sum ctxt =
  assert_equal true (is_even_sum [1; 2; 3]) ~msg:"is_even_sum (1)" ~printer:string_of_bool;
  assert_equal true (is_even_sum []) ~msg:"is_even_sum (2)" ~printer:string_of_bool;
  assert_equal false (is_even_sum [3; 3; 3]) ~msg:"is_even_sum (3)" ~printer:string_of_bool

let test_count_occ ctxt =
  assert_equal 2 (count_occ [2; 2; 3] 2) ~msg:"count_occ (1)" ~printer:string_of_int;
  assert_equal 1 (count_occ [1; 2; 1] 2) ~msg:"count_occ (2)" ~printer:string_of_int;
  assert_equal 3 (count_occ [1; 1; 1] 1) ~msg:"count_occ (3)" ~printer:string_of_int

let test_dup_list ctxt =
  assert_equal true (dup_list [1; 1]) ~msg:"dup_list (1)" ~printer:string_of_bool;
  assert_equal true (dup_list [2; 1; 2]) ~msg:"dup_list (2)" ~printer:string_of_bool;
  assert_equal false (dup_list [1; 2]) ~msg:"dup_list (3)" ~printer:string_of_bool

let test_elem ctxt =
  assert_equal false (elem 3 (create_set [])) ~msg:"elem (1)" ~printer:string_of_bool;
  assert_equal true (elem 5 (create_set [2;3;5;7;9])) ~msg:"elem (2)" ~printer:string_of_bool;
  assert_equal false (elem 4 (create_set [2;3;5;7;9])) ~msg:"elem (3)" ~printer:string_of_bool

let test_subset ctxt =
  assert_equal true (subset (create_set [2]) (create_set [2;3;5;7;9])) ~msg:"subset (1)" ~printer:string_of_bool;
  assert_equal true (subset (create_set [3;5]) (create_set [2;3;5;7;9])) ~msg:"subset (2)" ~printer:string_of_bool;
  assert_equal false (subset (create_set [4;5]) (create_set [2;3;5;7;9])) ~msg:"subset (3)" ~printer:string_of_bool

let test_remove ctxt =
  assert_set_equal_msg (create_set []) (remove 5 (create_set [])) ~msg:"remove (1)";
  assert_set_equal_msg (create_set [2;3;7;9]) (remove 5 (create_set [2;3;5;7;9])) ~msg:"remove (2)";
  assert_set_equal_msg (create_set [2;3;5;7;9]) (remove 4 (create_set [2;3;5;7;9])) ~msg:"remove (3)"

let test_union ctxt =
  assert_set_equal_msg (create_set [2;3;5]) (union (create_set []) (create_set [2;3;5])) ~msg:"union (1)";
  assert_set_equal_msg (create_set [2;3;5;7;9]) (union (create_set [2;5]) (create_set [3;7;9])) ~msg:"union (2)";
  assert_set_equal_msg (create_set [2;3;7;9]) (union (create_set [2;3;9]) (create_set [2;7;9])) ~msg:"union (3)"

let test_diff ctxt =
  assert_set_equal_msg (create_set [1]) (diff (create_set [1;2;3]) (create_set [2;3])) ~msg:"diff (1)";
  assert_set_equal_msg (create_set ['b';'c';'d']) (diff (create_set ['a';'b';'c';'d']) (create_set ['a';'e';'i';'o';'u'])) ~msg:"diff (2)";
  assert_set_equal_msg (create_set ["hello";"ocaml"]) (diff (create_set ["hello";"ocaml"]) (create_set ["hi";"ruby"])) ~msg:"diff (3)"

let test_cat ctxt =
  assert_set_equal_msg (create_set [("z","a");("z","b")]) (cat "z" (create_set ["a";"b"])) ~msg:"cat (1)";
  assert_set_equal_msg (create_set []) (cat 1 (create_set [])) ~msg:"cat (2)"

let suite =
  "public" >::: [
    "dup" >:: test_dup;
    "head_divisor" >:: test_head_divisor;
    "second_element" >:: test_second_element;
    "max_first_three" >:: test_max_first_three;

    "cubes" >:: test_cubes;
    "sum_odd" >:: test_sum_odd;
    "is_even_sum" >:: test_is_even_sum;
    "count_occ" >:: test_count_occ;
    "dup_list" >:: test_dup_list;

    "elem" >:: test_elem;
    "subset" >:: test_subset;
    "remove" >:: test_remove;
    "union" >:: test_union;
    "diff" >:: test_diff;
    "cat" >:: test_cat
  ]

let _ = run_test_tt_main suite
