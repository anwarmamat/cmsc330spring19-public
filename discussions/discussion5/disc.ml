(********************)
(* String Functions *)
(********************)

(* Joins together the strings in xs by separator sep
   e.g. join ["cat"; "dog"; "fish"] "," = "cat,dog,fish". *)
let join (xs : string list) (sep : string) : string =
  match xs with
    [] -> ""
  | h::t -> List.fold_left (^) h (List.map ((^) sep) t)

(********************)
(* Option Functions *)
(********************)

(* Converts an option to a list. Some is a singleton containing
   the value, while None is an empty list. *)
let list_of_option (o : 'a option) : 'a list =
  match o with
    Some x -> [x]
  | None -> []

(* Returns the first option that contains a value, None otherwise
   e.g. getFirst (Some 1) (Some 2) = Some 1 *)
let get_first (o : 'a option) (p : 'a option) : 'a option =
  match o, p with
    Some x, _ -> o
  | _, _ -> p

(* If the pair's key matches k returns the value as an option. Otherwise
   return None. *)
let match_key (k : 'k) (p : ('k * 'v)) : 'v option =
  match p with
    (k', v) when k = k' -> Some v
  | _ -> None

(************************)
(* Dictionary Functions *)
(************************)

(* Here is the type for dictionaries *)
type ('k, 'v) dict = ('k * 'v) list

(* Creates a key-value pair association in the dictionary
   (later bindings should shadow earlier ones) *)
let set (d : ('k, 'v) dict) (k : 'k) (v : 'v) : ('k, 'v) dict =
  (k, v)::d

(* Returns the value associated with a key (as an option) *)
let get (d : ('k, 'v) dict) (k : 'k) : 'v option =
  List.fold_right get_first (List.map (match_key k) d) None

(* Given a list of keys, returns a list of options of the associated
   values (and None if the key wasn't found). *)
let get_some_values (d : ('k, 'v) dict) (ks : 'k list) : 'v option list =
  List.map (get d) ks

(* Given a list of keys, returns a list of the values associated
   with the keys. *)
let get_values (d : ('k, 'v) dict) (ks : 'k list) : 'v list =
  List.fold_left (@) [] (List.map list_of_option (get_some_values d ks))
