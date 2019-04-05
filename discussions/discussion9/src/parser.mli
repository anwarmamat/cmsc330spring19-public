type expr =
| Int of int
| Plus of expr * expr
| Mult of expr * expr

val parser : Lexer.token list -> expr
