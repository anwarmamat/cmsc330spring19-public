type int_tree =
    IntLeaf
  | IntNode of int_tree * int_tree * int

val empty_int_tree : int_tree


val int_size : int_tree -> int
val int_max : int_tree -> int
val int_insert : int -> int_tree -> int_tree
val int_mem : int -> int_tree -> bool
val int_insert_all : int list -> int_tree -> int_tree
val int_as_list : int_tree -> int list

type 'a atree =
    Leaf
  | Node of 'a * 'a atree * 'a atree
type 'a compfn = 'a -> 'a -> int
type 'a ptree = 'a compfn * 'a atree
val empty_ptree : 'a compfn -> 'a ptree

val pinsert : 'a -> 'a ptree -> 'a ptree
val pmem : 'a -> 'a ptree -> bool
val pinsert_all : 'a list -> 'a ptree -> 'a ptree
val p_as_list : 'a ptree -> 'a list
val pmap : ('a -> 'a) -> 'a ptree -> 'a ptree

type node = int
type edge = { src : node; dst : node; }
type graph = { nodes : int_tree; edges : edge list; }
val empty_graph : graph
val add_edge : edge -> graph -> graph
val add_edges : edge list -> graph -> graph

val graph_empty : graph -> bool
val graph_size : graph -> int
val is_dst : node -> edge -> bool
val src_edges : node -> graph -> edge list
val reachable : node -> graph -> int_tree
