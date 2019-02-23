open OUnit2
open P2b.Data
open P2b.Funs
open P2b.Higher

let test_high_order_1 ctxt =
  assert_equal 0 @@ (len []);
  assert_equal 1 @@ (len [1]);
  assert_equal 5 @@ (len [1; 2; 2; 1; 3]);
  
  assert_equal 0 @@ (count_greater [] 5);
  assert_equal 0 @@ (count_greater [5] 5);
  assert_equal 3 @@ (count_greater [8; 5; 6; 6; 3] 5);

  assert_equal [] @@ (greater_tuple []);
  assert_equal [(1, 0)] @@ (greater_tuple [1]);
  assert_equal [(1, 3); (2, 1); (2, 1); (1, 3); (3, 0)] @@ (greater_tuple [1; 2; 2; 1; 3])
  
let test_high_order_2 ctxt =
  assert_equal [] @@ (rm [] 1);
  assert_equal [2] @@ (rm [2] 2);
  assert_equal [3;3] @@ (rm [3; 3] 3);
  assert_equal [1; 3; 1; 2] @@ (rm [1; 3; 1; 2] 5);
  assert_equal [1; 1] @@ (rm [1; 3; 1; 2] 1)

let test_int_tree ctxt =
  let t0 = empty_int_tree in
  let t1 = (int_insert 3 (int_insert 11 t0)) in
  let t2 = (int_insert 13 t1) in
  let t3 = (int_insert 17 (int_insert 3 (int_insert 1 t2))) in

  assert_equal 0 @@ (int_size t0);
  assert_equal 2 @@ (int_size t1);
  assert_equal 3 @@ (int_size t2);
  assert_equal 5 @@ (int_size t3);

  assert_raises (Invalid_argument("int_max")) (fun () -> int_max t0);
  assert_equal 11 @@ int_max t1;
  assert_equal 13 @@ int_max t2;
  assert_equal 17 @@ int_max t3

(* if something is inserted into an empty tree, int_size should return positive value *)
let test_int_tree_qcheck =
  QCheck.Test.make
    ~count:500
    ~name: "test_int_tree_qcheck"
    (QCheck.int)
    (fun i -> int_size (int_insert i (empty_int_tree)) > 0)

let test_ptree_1 ctxt =
  let r0 = empty_ptree Pervasives.compare in
  let r1 = (pinsert 2 (pinsert 1 r0)) in
  let r2 = (pinsert 3 r1) in
  let r3 = (pinsert 5 (pinsert 3 (pinsert 11 r2))) in
  let a = [5;6;8;3;11;7;2;6;5;1]  in
  let x = [5;6;8;3;0] in
  let z = [7;5;6;5;1] in
  let r4a = pinsert_all x r1 in
  let r4b = pinsert_all z r1 in

  let strlen_comp x y = Pervasives.compare (String.length x) (String.length y) in
  let k0 = empty_ptree strlen_comp in
  let k1 = (pinsert "hello" (pinsert "bob" k0)) in
  let k2 = (pinsert "sidney" k1) in
  let k3 = (pinsert "yosemite" (pinsert "ali" (pinsert "alice" k2))) in
  let b = ["hello"; "bob"; "sidney"; "kevin"; "james"; "ali"; "alice"; "xxxxxxxx"] in

  assert_equal [false;false;false;false;false;false;false;false;false;false] @@ map (fun y -> pmem y r0) a;
  assert_equal [false;false;false;false;false;false;true;false;false;true] @@ map (fun y -> pmem y r1) a;
  assert_equal [false;false;false;true;false;false;true;false;false;true] @@ map (fun y -> pmem y r2) a;
  assert_equal [true;false;false;true;true;false;true;false;true;true] @@ map (fun y -> pmem y r3) a;

  assert_equal [false;false;false;false;false;false;false;false] @@ map (fun y -> pmem y k0) b;
  assert_equal [true;true;false;true;true;true;true;false] @@ map (fun y -> pmem y k1) b;
  assert_equal [true;true;true;true;true;true;true;false] @@ map (fun y -> pmem y k2) b;
  assert_equal [true;true;true;true;true;true;true;true] @@ map (fun y -> pmem y k3) b;

  assert_equal [true;true;true;true;true] @@ map (fun y -> pmem y r4a) x;
  assert_equal [true;true;false;false;false] @@ map (fun y -> pmem y r4b) x;
  assert_equal [false;true;true;true;true] @@ map (fun y -> pmem y r4a) z;
  assert_equal [true;true;true;true;true] @@ map (fun y -> pmem y r4b) z

let test_ptree_2 ctxt = 
  let q0 = empty_ptree Pervasives.compare in
  let q1 = pinsert 1 (pinsert 2 (pinsert 0 q0)) in
  let q2 = pinsert 5 (pinsert 11 (pinsert (-1) q1)) in
  let q3 = pinsert (-7) (pinsert (-3) (pinsert 9 q2)) in
  let f = (fun x -> x + 10) in
  let g = (fun y -> y * (-1)) in

  assert_equal [] @@ p_as_list q0;
  assert_equal [0;1;2] @@ p_as_list q1;
  assert_equal [-1;0;1;2;5;11] @@ p_as_list q2;
  assert_equal [-7;-3;-1;0;1;2;5;9;11] @@ p_as_list q3;

  assert_equal [] @@ p_as_list (pmap f q0);
  assert_equal [10;11;12] @@ p_as_list (pmap f q1);
  assert_equal [9;10;11;12;15;21] @@ p_as_list (pmap f q2);
  assert_equal [3;7;9;10;11;12;15;19;21] @@ p_as_list (pmap f q3);

  assert_equal [] @@ p_as_list (pmap g q0);
  assert_equal [-2;-1;0] @@ p_as_list (pmap g q1);
  assert_equal [-11;-5;-2;-1;0;1] @@ p_as_list (pmap g q2);
  assert_equal [-11;-9;-5;-2;-1;0;1;3;7] @@ p_as_list (pmap g q3)

let test_graph_1 ctxt =
  let g = add_edges
      [ { src = 1; dst = 2; };
        { src = 2; dst = 3; };
        { src = 3; dst = 4; };
        { src = 4; dst = 5; } ] empty_graph in
  let g2 = add_edges
      [ { src = 1; dst = 2; };
        { src = 3; dst = 4; };
        { src = 4; dst = 3; } ] empty_graph in
  let g3 = add_edges
      [ { src = 1; dst = 2; };
        { src = 1; dst = 3; };
        { src = 3; dst = 2; };
        { src = 2; dst = 1; } ] empty_graph in

  assert_equal true @@ graph_empty empty_graph;
  assert_equal false @@ graph_empty g;
  assert_equal false @@ graph_empty g2;

  assert_equal 0 @@ graph_size empty_graph;
  assert_equal 5 @@ graph_size g;
  assert_equal 4 @@ graph_size g2;
  assert_equal 3 @@ graph_size g3

let test_graph_2 ctxt =
  let p = add_edges
      [ { src = 1; dst = 2; };
        { src = 2; dst = 3; };
        { src = 3; dst = 4; };
        { src = 4; dst = 5; } ] empty_graph in
  let p2 = add_edges
      [ { src = 1; dst = 2; };
        { src = 3; dst = 4; };
        { src = 4; dst = 3; } ] empty_graph in
  let p3 = add_edges
      [ { src = 1; dst = 2; };
        { src = 1; dst = 3; };
        { src = 3; dst = 2; };
        { src = 2; dst = 1; } ] empty_graph in

  assert_equal [2] @@ (map (fun { dst = d } -> d) (src_edges 1 p));
  assert_equal [3] @@ (map (fun { dst = d } -> d) (src_edges 2 p));
  assert_equal [] @@ (map (fun { dst = d } -> d) (src_edges 5 p));
  assert_equal [2] @@ (map (fun { dst = d } -> d) (src_edges 1 p2));
  assert_equal [] @@ (map (fun { dst = d } -> d) (src_edges 2 p2));
  assert_equal [4] @@ (map (fun { dst = d } -> d) (src_edges 3 p2));
  assert_equal [1] @@ (map (fun { dst = d } -> d) (src_edges 2 p3));
  assert_equal [] @@ (map (fun { dst = d } -> d) (src_edges 4 p3));
  assert_equal (List.sort compare [2;3]) @@ (List.sort compare (map (fun { dst = d } -> d) (src_edges 1 p3)));

  assert_equal [true] @@ (map (fun e -> is_dst 2 e) (src_edges 1 p));
  assert_equal [true] @@ (map (fun e -> is_dst 2 e) (src_edges 1 p2));
  assert_equal (List.sort compare [true;false]) @@ (List.sort compare (map (fun e -> is_dst 2 e) (src_edges 1 p3)))

let suite =
  "public" >::: [
    "high_order_1" >:: test_high_order_1;
    "high_order_2" >:: test_high_order_2;
    "int_tree" >:: test_int_tree;
    QCheck_runner.to_ounit2_test test_int_tree_qcheck;
    "ptree_1" >:: test_ptree_1;
    "ptree_2" >:: test_ptree_2;
    "graph_1" >:: test_graph_1;
    "graph_2" >:: test_graph_2
  ]

let _ = run_test_tt_main suite
