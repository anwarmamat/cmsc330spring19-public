open OUnit2
open TestUtils
open Disc

let test_find_expensive ctxt =
  assert_equal true (cmp_float 0.0 (find_expensive [])) ~msg:"find_expensive (1)";
  assert_equal true (cmp_float 50.0 (find_expensive [{item="sofritas"; cost=50.0}; {item="chicken"; cost=50.0}; {item="guac"; cost=20.0}])) ~msg:"find_expensive (2)";
  assert_equal true (cmp_float 7.15 (find_expensive [{item="sofritas"; cost=6.84}; {item="chicken"; cost=7.15}; {item="guac"; cost=2.15}])) ~msg:"find_expensive (3)"

let test_sum_list_list ctxt =
  assert_equal 0 (sum_list_list []) ~msg:"sum_list_list (1)" ~printer:string_of_int;
  assert_equal 6 (sum_list_list [[]; [1]; [2; 3]]) ~msg:"sum_list_list (2)" ~printer:string_of_int;
  assert_equal 4 (sum_list_list [[-1; 1]; [-2; 3]; [-5; 8]]) ~msg:"sum_list_list (3)" ~printer:string_of_int

let test_full_names ctxt =
  assert_equal [] (full_names []) ~msg:"full_names (1)" ~printer:string_of_string_list;
  assert_equal ["Anwar Mamat"; "Michael William Hicks"] (full_names [{ first = "Anwar"; middle = None; last = "Mamat" }; { first = "Michael"; middle = Some "William"; last = "Hicks" }]) ~msg:"full_names (2)" ~printer:string_of_string_list;
  assert_equal ["Tide Pods"] (full_names [{first="Tide"; middle=None; last="Pods"}]) ~msg:"full_names (3)" ~printer:string_of_string_list

let test_sum_vectors ctxt =
  assert_equal { x = 0; y = 0 } (sum_vectors []) ~msg:"sum_vectors (1)";
  assert_equal { x = 4; y = 6 } (sum_vectors [{ x = 1; y = 2 }; { x = 3; y = 4 }]) ~msg:"sum_vectors (2)";
  assert_equal { x = 20; y = 100 } (sum_vectors [{ x = 10; y = 20 }; { x = 30; y = 40 }; { x = (-20); y = 40 }]) ~msg:"sum_vectors (3)"

let test_my_map ctxt =
  assert_equal [] (my_map (fun x -> x + 1) []) ~msg:"my_map (1)" ~printer:string_of_int_list;
  assert_equal [2;3;4] (my_map (fun x -> x + 1) [1;2;3]) ~msg:"my_map (2)" ~printer:string_of_int_list;
  assert_equal ["Tide Pods"] (my_map (fun x -> x ^ " Pods") ["Tide"]) ~msg:"my_map (3)" ~printer:string_of_string_list

let suite =
  "public" >::: [
    "find_expensive" >:: test_find_expensive;
    "sum_list_list" >:: test_sum_list_list;
    "full_names" >:: test_full_names;
    "sum_vectors" >::  test_sum_vectors;
    "my_map" >:: test_my_map
  ]

let _ = run_test_tt_main suite
