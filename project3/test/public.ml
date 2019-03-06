open OUnit2
open SmallCTypes
open P3.Eval
open Utils
open TestUtils

let env1 = [("var1", Int_Val 4); ("var2", Bool_Val false)]

let test_expr_basic ctxt =
  let i = 5 in assert_equal (Int_Val i) (eval_expr [] (Int i));
  let i = (-10) in assert_equal (Int_Val i) (eval_expr [] (Int i));
  assert_equal (Bool_Val true) (eval_expr env1 (Bool true));
  assert_equal (Bool_Val false) (eval_expr env1 (Bool false));
  assert_equal (Int_Val 4) (eval_expr env1 (ID "var1"));
  assert_equal (Bool_Val false) (eval_expr env1 (ID "var2"))

let test_expr_ops ctxt =
  assert_equal (Int_Val 8) (eval_expr env1 (Add ((ID "var1"), (Int 4))));
  assert_equal (Int_Val (-2)) (eval_expr env1 (Add ((ID "var1"), (Int (-6)))));
  assert_equal (Int_Val 42) (eval_expr [] (Sub (Int 50, Int 8)));
  assert_equal (Int_Val (-2)) (eval_expr env1 (Sub (ID "var1", Int 6)));
  assert_equal (Int_Val 64) (eval_expr [] (Mult (Int 8, Int 8)));
  assert_equal (Int_Val (-10)) (eval_expr [] (Mult (Int 5, Int (-2))));
  assert_equal (Int_Val 10) (eval_expr [] (Div (Int 70, Int 7)));
  assert_equal (Int_Val (50/3)) (eval_expr [] (Div (Int 50, Int 3)));
  assert_equal (Int_Val 9) (eval_expr [] (Pow (Int 3, Int 2)));

  assert_equal (Bool_Val true) (eval_expr [] (Or (Bool false, Bool true)));
  assert_equal (Bool_Val false) (eval_expr env1 (Or (Bool false, ID "var2")));
  assert_equal (Bool_Val false) (eval_expr [] (And (Bool false, Bool true)));
  assert_equal (Bool_Val true) (eval_expr [] (And (Bool true, Bool true)));
  assert_equal (Bool_Val true) (eval_expr [] (Not (Bool false)));
  assert_equal (Bool_Val false) (eval_expr [] (Not (Bool true)));

  assert_equal (Bool_Val false) (eval_expr env1 (Equal (ID "var1", Int 10)));
  assert_equal (Bool_Val true) (eval_expr env1 (Equal (ID "var2", Bool false)));
  assert_equal (Bool_Val true) (eval_expr env1 (NotEqual (ID "var1", Int 10)));
  assert_equal (Bool_Val false) (eval_expr env1 (NotEqual (ID "var2", ID "var2")));

  assert_equal (Bool_Val true) (eval_expr env1 (Greater (ID "var1", Int 2)));
  assert_equal (Bool_Val false) (eval_expr env1 (Greater (Int 2, ID "var1")));
  assert_equal (Bool_Val true) (eval_expr env1 (Less (ID "var1", Int 10)));
  assert_equal (Bool_Val false) (eval_expr env1 (Less (ID "var1", Int 2)));
  assert_equal (Bool_Val true) (eval_expr [] (GreaterEqual (Int 0, Int 0)));
  assert_equal (Bool_Val false) (eval_expr [] (GreaterEqual (Int 0, Int 1)));
  assert_equal (Bool_Val false) (eval_expr [] (LessEqual (Int 1, Int 0)))

let test_expr_fail ctxt =
  assert_expr_fail expr_env (Add(Int 1, ID "p"));
  assert_expr_fail expr_env (Mult(Bool false, ID "y"));
  assert_expr_fail expr_env (Sub(ID "q", Int 1));
  assert_expr_fail expr_env (Div(ID "y", Bool false));
  assert_expr_fail expr_env (Pow(ID "x", Bool true));
  assert_expr_fail expr_env (Or(Int 1, ID "q"));
  assert_expr_fail expr_env (And(ID "p", Int 0));
  assert_expr_fail expr_env (Not(ID "x"));
  assert_expr_fail expr_env (Greater(ID "x", ID "p"));
  assert_expr_fail expr_env (Less(ID "q", ID "y"));
  assert_expr_fail expr_env (GreaterEqual(ID "q", ID "x"));
  assert_expr_fail expr_env (LessEqual(ID "x", ID "q"));
  assert_expr_fail expr_env (Equal(ID "p", ID "x"));
  assert_expr_fail expr_env (NotEqual(ID "p", ID "x"));
  assert_expr_fail expr_env (Add(ID "x", Add(ID "y", Bool true)));
  assert_expr_fail expr_env (Mult(Mult(ID "x", Bool false), ID "y"));
  assert_expr_fail expr_env (Sub(ID "x", Sub(Bool false, Int 1)));
  assert_expr_fail expr_env (Div(ID "y", Div(Bool true, ID "x")));
  assert_expr_fail expr_env (Pow(ID "x", Pow(Bool false, ID "y")));
  assert_expr_fail expr_env (Or(Or(ID "q", Int 1), ID "p"));
  assert_expr_fail expr_env (And(ID "q", And(Int 1, ID "q")));
  assert_expr_fail expr_env (And(Not(ID "p"), Not(Int 1)));
  assert_expr_fail expr_env (Equal(ID "p", Greater(ID "y", Bool false)));
  assert_expr_fail expr_env (And(ID "q", Less(Bool true, ID "y")));
  assert_expr_fail expr_env (Or(GreaterEqual(ID "y", Bool true), ID "q"));
  assert_expr_fail expr_env (NotEqual(LessEqual(ID "x", Bool true), ID "q"));
  assert_expr_fail expr_env (Equal(Equal(ID "x", Bool false), ID "q"));
  assert_expr_fail expr_env (Equal(Equal(ID "y", Bool true), ID "p"))

(* Simple sequence *)
let test_stmt_basic ctxt = 
  let env = [("a", Bool_Val true); ("b", Int_Val 7)] in assert_stmt_success env env NoOp;
  assert_stmt_success [] [("a", Int_Val 0); ("b", Int_Val 0); ("x", Bool_Val false); ("y", Bool_Val false)] (Seq(Declare(Int_Type, "a"), Seq(Declare(Int_Type, "b"), Seq(Declare(Bool_Type, "x"), Seq(Declare(Bool_Type, "y"), NoOp)))));
  assert_stmt_success [] [("a", Int_Val 0)] (Seq(Declare(Int_Type, "a"), Seq(Print(ID "a"), NoOp)))
    ~output:"0\n";
  assert_stmt_success [] [("a", Bool_Val false)] (Seq(Declare(Bool_Type, "a"), Seq(Print(ID "a"), NoOp)))
    ~output:"false\n"

let test_stmt_control ctxt =
  assert_stmt_success [("a", Bool_Val true)] [("a", Bool_Val true); ("b", Int_Val 5)] (Seq(Declare(Int_Type, "b"), Seq(If(ID "a", Seq(Assign("b", Int 5), NoOp), Seq(Assign("b", Int 10), NoOp)), NoOp)));
  assert_stmt_success [("a", Bool_Val false)] [("a", Bool_Val false); ("b", Int_Val 10)] (Seq(Declare(Int_Type, "b"), Seq(If(ID "a", Seq(Assign("b", Int 5), NoOp), Seq(Assign("b", Int 10), NoOp)), NoOp)))

let test_define_1 = create_system_test [] [("a", Int_Val 0)] (Seq(Declare(Int_Type, "a"), NoOp))
let test_define_2 = create_system_test [] [("a", Bool_Val false)] (Seq(Declare(Bool_Type, "a"), NoOp))
let test_assign_1 = create_system_test [] [("a", Int_Val 100)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), NoOp)))
let test_assign_2 = create_system_test [] [("a", Bool_Val true)] (Seq(Declare(Bool_Type, "a"), Seq(Assign("a", Bool true), NoOp)))
let test_assign_exp = create_system_test [] [("a", Int_Val 0)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Mult(Int 100, ID "a")), Seq(Print(ID "a"), NoOp)))) ~output:"0\n"
let test_notequal = create_system_test [] [("a", Int_Val 100)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(If(NotEqual(ID "a", Int 100), Seq(Assign("a", Int 200), NoOp), Seq(Print(ID "a"), NoOp)), NoOp)))) ~output:"100\n"
let test_equal = create_system_test [] [("a", Int_Val 200)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(If(Equal(ID "a", Int 100), Seq(Assign("a", Int 200), Seq(Print(ID "a"), NoOp)), NoOp), NoOp)))) ~output:"200\n"
let test_less = create_system_test [] [("a", Int_Val 200)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 150), Seq(If(And(Less(ID "a", Int 200), Greater(ID "a", Int 100)), Seq(Assign("a", Int 200), Seq(Print(ID "a"), NoOp)), NoOp), NoOp)))) ~output:"200\n"
let test_exp_1 = create_system_test [] [("a", Int_Val 322)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Add(Int 2, Mult(Int 5, Pow(Int 4, Int 3)))), Seq(Print(ID "a"), NoOp)))) ~output:"322\n"
let test_exp_2 = create_system_test [] [("a", Int_Val 8002)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Add(Int 2, Pow(Mult(Int 5, Int 4), Int 3))), Seq(Print(ID "a"), NoOp))))  ~output:"8002\n"
let test_exp_3 = create_system_test [] [("a", Int_Val (-1))] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Add(Int 1, Sub(Div(Int 5, Int 4), Int 3))), Seq(Print(ID "a"), NoOp)))) ~output:"-1\n"
let test_ifelse = create_system_test [] [("a", Int_Val 200)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(If(Greater(ID "a", Int 10), Seq(Assign("a", Int 200), NoOp), Seq(Assign("a", Int 300), NoOp)), NoOp))))
let test_if_else_while = create_system_test [] [("b", Int_Val 0);("a", Int_Val 200)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(Declare(Int_Type, "b"), Seq(If(Greater(ID "a", Int 10), Seq(Assign("a", Int 200), NoOp), Seq(Assign("b", Int 10), Seq(While(Less(Mult(ID "b", Int 2), ID "a"), Seq(Assign("b", Add(ID "b", Int 2)), Seq(Print(ID "b"), NoOp))), Seq(Assign("a", Int 300), NoOp)))), NoOp)))))
let test_while = create_system_test [] [("a", Int_Val 10); ("b", Int_Val 11)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 10), Seq(Declare(Int_Type, "b"), Seq(Assign("b", Int 1), Seq(While(Less(ID "b", ID "a"), Seq(Print(ID "b"), Seq(Assign("b", Add(ID "b", Int 2)), NoOp))), NoOp))))))  ~output:"1\n3\n5\n7\n9\n"
let test_dowhile = create_system_test [] [("a", Int_Val 10); ("b", Int_Val 11)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 10), Seq(Declare(Int_Type, "b"), Seq(Assign("b", Int 1), Seq(DoWhile(Seq(Print(ID "b"), Seq(Assign("b", Add(ID "b", Int 2)), NoOp)), Less(ID "b", ID "a")), NoOp))))))  ~output:"1\n3\n5\n7\n9\n"
let test_nested_ifelse = create_system_test [] [("a", Int_Val 400)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 100), Seq(If(Greater(ID "a", Int 10), Seq(Assign("a", Int 200), Seq(If(Less(ID "a", Int 20), Seq(Assign("a", Int 300), NoOp), Seq(Assign("a", Int 400), NoOp)), NoOp)), Seq(Assign("a", Int 500), NoOp)), NoOp))))
let test_nested_while = create_system_test [] [("sum", Int_Val 405);("j", Int_Val 10); ("i", Int_Val 10)] (Seq(Declare(Int_Type, "i"), Seq(Declare(Int_Type, "j"), Seq(Assign("i", Int 1), Seq(Declare(Int_Type, "sum"), Seq(Assign("sum", Int 0), Seq(While(Less(ID "i", Int 10), Seq(Assign("j", Int 1), Seq(While(Less(ID "j", Int 10), Seq(Assign("sum", Add(ID "sum", ID "j")), Seq(Assign("j", Add(ID "j", Int 1)), NoOp))), Seq(Assign("i", Add(ID "i", Int 1)), NoOp)))), NoOp)))))))
let test_main = create_system_test [] [] NoOp
let test_test_1 = create_system_test [] [("a", Int_Val 10);("sum", Int_Val 45); ("b", Int_Val 10)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 10), Seq(Declare(Int_Type, "b"), Seq(Assign("b", Int 1), Seq(Declare(Int_Type, "sum"), Seq(Assign("sum", Int 0), Seq(While(Less(ID "b", ID "a"), Seq(Assign("sum", Add(ID "sum", ID "b")), Seq(Assign("b", Add(ID "b", Int 1)), Seq(Print(ID "sum"), Seq(If(Greater(ID "a", ID "b"), Seq(Print(Int 10), NoOp), Seq(Print(Int 20), NoOp)), Seq(Print(ID "sum"), NoOp)))))), NoOp)))))))) ~output:"1\n10\n1\n3\n10\n3\n6\n10\n6\n10\n10\n10\n15\n10\n15\n21\n10\n21\n28\n10\n28\n36\n10\n36\n45\n20\n45\n"
let test_test_2 = create_system_test [] [("a", Int_Val 10);("c", Int_Val 0); ("b", Int_Val 20)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 10), Seq(Declare(Int_Type, "b"), Seq(Assign("b", Int 20), Seq(Declare(Int_Type, "c"), Seq(If(Less(ID "a", ID "b"), Seq(If(Less(Pow(ID "a", Int 2), Pow(ID "b", Int 3)), Seq(Print(ID "a"), NoOp), Seq(Print(ID "b"), NoOp)), NoOp), Seq(Assign("c", Int 1), Seq(While(Less(ID "c", ID "a"), Seq(Print(ID "c"), Seq(Assign("c", Add(ID "c", Int 1)), NoOp))), NoOp))), NoOp))))))) ~output:"10\n"
let test_test_3 = create_system_test [] [("a", Int_Val 10);("c", Int_Val 64); ("b", Int_Val 2)] (Seq(Declare(Int_Type, "a"), Seq(Assign("a", Int 10), Seq(Declare(Int_Type, "b"), Seq(Assign("b", Int 2), Seq(Declare(Int_Type, "c"), Seq(Assign("c", Add(ID "a", Mult(ID "b", Pow(Int 3, Int 3)))), Seq(Print(ID "c"), Seq(Print(Equal(ID "c", Int 1)), NoOp))))))))) ~output:"64\nfalse\n"

let test_stmt_fail_basic _ = 
  assert_stmt_fail stmt_env (Seq(Print(Greater(Add(ID "x", ID "y"), Bool false)), NoOp)) ~expect:DeclareExpect;
  assert_stmt_fail stmt_env (Seq(Print(Not(Or(ID "p", ID "q"))), NoOp)) ~expect:DeclareExpect;
  assert_stmt_fail stmt_env (Seq(Declare(Int_Type, "y"), Seq(Declare(Int_Type, "x"), NoOp))) ~expect:DeclareExpect;
  assert_stmt_fail stmt_env (Seq(Declare(Bool_Type, "q"), Seq(Declare(Bool_Type, "p"), NoOp))) ~expect:DeclareExpect;
  assert_stmt_fail stmt_env (Seq(Declare(Int_Type, "y"), Seq(Declare(Bool_Type, "x"), NoOp))) ~expect:DeclareExpect;
  assert_stmt_fail stmt_env (Seq(Declare(Bool_Type, "q"), Seq(Declare(Int_Type, "p"), NoOp))) ~expect:DeclareExpect;
  assert_stmt_fail stmt_env (Seq(Assign("x", Bool false), NoOp));
  assert_stmt_fail expr_env (Seq(Assign("x", Add(ID "y", And(ID "p", ID "q"))), NoOp));
  assert_stmt_fail stmt_env (Seq(Assign("y", Int 1), NoOp)) ~expect:DeclareExpect;
  assert_stmt_fail expr_env (Seq(Assign("x", Greater(Add(ID "y", ID "x"), ID "z")), NoOp)) ~expect:DeclareExpect;
  assert_stmt_fail stmt_env (Seq(Assign("p", Int 1), NoOp));
  assert_stmt_fail expr_env (Seq(Assign("q", Or(ID "p", And(ID "x", ID "q"))), NoOp));
  assert_stmt_fail stmt_env (Seq(Assign("q", Bool false), NoOp)) ~expect:DeclareExpect;
  assert_stmt_fail expr_env (Seq(Assign("q", Or(ID "q", Not(And(ID "p", ID "r")))), NoOp)) ~expect:DeclareExpect

let test_stmt_fail_control _ = 
  assert_stmt_fail stmt_env (Seq(If(Int 0, Seq(Assign("x", Int 0), NoOp), Seq(Assign("x", Int 1), NoOp)), NoOp));
  assert_stmt_fail stmt_env (Seq(If(Or(ID "p", ID "q"), Seq(Assign("x", Int 0), NoOp), Seq(Assign("x", Int 1), NoOp)), NoOp)) ~expect:DeclareExpect;
  assert_stmt_fail expr_env (Seq(If(Div(ID "x", Mult(ID "y", Int 2)), Seq(Assign("x", Int 0), NoOp), Seq(Assign("x", Int 1), NoOp)), NoOp));
  assert_stmt_fail stmt_env (Seq(If(Bool true, Seq(Print(Not(ID "p")), Seq(Assign("p", Not(And(ID "p", ID "q"))), NoOp)), Seq(Assign("x", Sub(ID "x", ID "x")), NoOp)), NoOp)) ~expect:DeclareExpect;
  assert_stmt_fail expr_env (Seq(If(Bool false, Seq(Assign("x", Mult(ID "y", ID "y")), NoOp), Seq(Print(Mult(ID "x", And(ID "p", ID "x"))), Seq(Assign("x", Int 1), NoOp))), NoOp));
  assert_stmt_fail stmt_env (Seq(If(Bool false, Seq(Assign("p", Not(ID "p")), NoOp), Seq(Assign("x", Div(Mult(ID "x", ID "x"), ID "y")), Seq(Print(ID "x"), NoOp))), NoOp)) ~expect:DeclareExpect;
  assert_stmt_fail stmt_env (Seq(While(Int 0, Seq(Assign("x", Add(ID "x", Int 1)), NoOp)), NoOp));
  assert_stmt_fail stmt_env (Seq(While(NotEqual(Or(ID "p", ID "q"), Bool false), Seq(Assign("x", Add(ID "x", Int 1)), NoOp)), NoOp)) ~expect:DeclareExpect;
  assert_stmt_fail expr_env (Seq(While(Sub(ID "x", Add(ID "x", ID "y")), Seq(Assign("x", Add(ID "x", Int 1)), Seq(Print(Mult(ID "x", ID "x")), NoOp))), NoOp));
  assert_stmt_fail expr_env (Seq(While(Bool true, Seq(Assign("p", And(ID "p", ID "q")), Seq(Print(Add(ID "x", Less(ID "p", ID "q"))), NoOp))), NoOp))

let public = 
  "public" >::: [
    "expr_basic" >:: test_expr_basic;
    "expr_ops" >:: test_expr_ops;
    "expr_fail" >:: test_expr_fail;

    "stmt_basic" >:: test_stmt_basic;
    "stmt_control" >:: test_stmt_control;

    "define_1" >:: test_define_1;
    "define_2" >:: test_define_2;
    "assign_1" >:: test_assign_1;
    "assign_2" >:: test_assign_2;
    "assign_exp" >:: test_assign_exp;
    "notequal" >:: test_notequal;
    "equal" >:: test_equal;
    "less" >:: test_less;
    "exp_1" >:: test_exp_1;
    "exp_2" >:: test_exp_2;
    "exp_3" >:: test_exp_3;
    "ifelse" >:: test_ifelse;
    "if_else_while" >:: test_if_else_while;
    "while" >:: test_while;
    "dowhile" >:: test_dowhile;
    "nested_ifelse" >:: test_nested_ifelse;
    "nested_while" >:: test_nested_while;
    "main" >:: test_main;
    "test_1" >:: test_test_1;
    "test_2" >:: test_test_2;
    "test_3" >:: test_test_3;
    "stmt_fail_basic" >:: test_stmt_fail_basic;
    "stmt_fail_control" >:: test_stmt_fail_control
  ]

let _ = run_test_tt_main public
