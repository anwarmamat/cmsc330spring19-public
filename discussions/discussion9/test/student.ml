open OUnit2
open Disc.Lexer
open Disc.Parser
open Disc.Interpreter

let test_sanity ctxt = 
  assert_equal 1 1

let suite =
  "student" >::: [
    "sanity" >:: test_sanity
  ]

let _ = run_test_tt_main suite
