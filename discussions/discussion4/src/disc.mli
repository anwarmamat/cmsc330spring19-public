type chipotle_order = { item : string; cost : float }
type name_record = { first : string; middle : string option; last : string }
type vector = { x : int; y : int }

val find_expensive : chipotle_order list -> float
val map : ('a -> 'b) -> 'a list -> 'b list
val foldl : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
val full_names : name_record list -> string list
val sum_vectors : vector list -> vector
val sum_list_list : int list list -> int
val foldr : ('a -> 'b -> 'b) -> 'a list -> 'b -> 'b
val my_map : ('a -> 'b) -> 'a list -> 'b list
