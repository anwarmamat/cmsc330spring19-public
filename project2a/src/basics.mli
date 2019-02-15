val dup: 'a -> 'a -> 'a -> bool
val head_divisor : int list -> bool
val second_element : int list -> int
val max_first_three : int list -> int

val cubes : int -> int
val sum_odd : int list -> int
val is_even_sum : int list -> bool
val count_occ : 'a list -> 'a -> int
val dup_list : 'a list -> bool

val elem : 'a -> 'a list -> bool
val insert : 'a -> 'a list -> 'a list
val subset : 'a list -> 'a list -> bool
val eq : 'a list -> 'a list -> bool
val remove : 'a -> 'a list -> 'a list
val union : 'a list -> 'a list -> 'a list
val diff : 'a list -> 'a list -> 'a list
val cat : 'a -> 'b list -> ('a * 'b) list