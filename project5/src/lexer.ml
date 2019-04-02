open TokenTypes

let reg_space = Str.regexp "[ \n\t]+"

let reg_ID = Str.regexp "[a-zA-Z][a-zA-Z0-9]*"
let reg_int = Str.regexp "-?[0-9]+"

(* regexps for operators paired with the appropriate token, and the string's length *)
let reg_operators : (Str.regexp * (token * int)) list =
  List.map (fun (s, t, l) -> ((Str.regexp s), (t, l)))
    [
      ("(",  Tok_LParen, 1);
      (")",  Tok_RParen, 1);
      ("{",  Tok_LBrace, 1);
      ("}",  Tok_RBrace, 1);
      ("==", Tok_Equal, 2);
      ("!=", Tok_NotEqual, 2);
      ("=",  Tok_Assign, 1);
      (">",  Tok_Greater, 1);
      ("<",  Tok_Less, 1);
      (">=", Tok_GreaterEqual, 2);
      ("<=", Tok_LessEqual, 2);
      ("\\+",Tok_Add, 1);
      ("\\*",Tok_Mult, 1);
      ("\\^",Tok_Pow, 1)
      (* TODO: Fill in missing operators *)
    ]
;;

(* iterates through list of regexps, and returns token/length pair if one matches *)
let rec op_match s pos ops =
  match ops with
    | [] -> None
    | (re, (tk,l))::ops' ->
      if (Str.string_match re s pos) then Some (tk,l)
      else op_match s pos ops'

let tokenize str =
  let rec tok pos s acc = 
    if pos >= String.length s then
      List.rev @@ EOF::acc
    else if (Str.string_match reg_space s pos) then
      tok (pos + 1) s acc
    else if (Str.string_match reg_ID s pos) then
      let id_token = Str.matched_string s in
      (* TODO: Need to match keywords, booleans, etc. not just identifiers *)
      tok (pos + (String.length id_token)) s ((Tok_ID id_token)::acc)
    (* TODO: Match numbers *)  
    else
      match (op_match s pos reg_operators) with
   Some (tk, len) -> tok (pos + len) s (tk::acc)
       | None -> raise (InvalidInputException "tokenize") in

    tok 0 str []
