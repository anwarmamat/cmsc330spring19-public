# Project 2B: OCaml Higher Order Functions and Data

Due: March 1 (Late March 2) at 11:59:59 PM

Points: 36P/16R/48S

## Introduction
The goal of this project is to increase your familiarity with programming in OCaml and give you practice using higher order functions and user-defined types. You will have to write a number of small functions, the specifications of which are given below. Some of them start out as code we provide you. In our reference solution, each function typically requires writing or modifying 1-8 lines of code.

You should be able to complete Part 1 after the lecture on high-order functions and the remaining sections after the lecture on user-defined types.

### Ground Rules
In your code, you may **only** use library functions found in the [`Pervasives` module][pervasives doc] and the functions provided in `funs.ml`. You **may** use the `@` operator. You **cannot** use the `List` module. You **may not** use any imperative structures of OCaml such as references.

We will check that you did not use any features that were not allowed. You will **lose** points if you fail these tests. 

At a few points in this project, you will need to raise an `Invalid_argument` exception. Use the `invalid_arg` function to do so:
```
invalid_arg "something went wrong"
```
Use the error message that the function specifies as the argument.

You can run the tests by doing `dune runtest -f`. We recommend you write student tests in `test/student.ml`.

You can run your own tests by doing `dune utop src` (assuming you have `utop`). Then after doing  `open P2b.Funs` ,  `open P2b.Higher`,  and `open P2b.Data` you should be able to use any of the functions.

## Part 1: High Order Functions
Write the following functions in `higher.ml` using `map`, `fold`, or `fold_right` as defined in the file `funs.ml`. You **must** use `map`, `fold`, or `fold_right` to complete these functions, so no functions in `higher.ml` should be defined using the `rec` keyword. You will lose points if this rule is not followed. Use the other provided functions in `funs.ml` to make completing the functions easier. 

Some of these functions will require just map or fold, but some will require a combination of the two. The map/reduce design pattern may come in handy: Map over a list to convert it to a new list which you then process a second time using fold. The idea is that you first process the list using map, and then reduce the resulting list using fold.


#### len lst
- **Type**: `'a list -> int`
- **Description**: Returns how many elements are in `lst`.
- **Examples:**
```
len [] = 0
len ["foo";"bar"] = 2
len [1; 2; 2; 1; 3] = 5
```

#### count_greater lst target
- **Type**: `'a list -> 'a -> int`
- **Description**: Given a list, returns the number of elements in lst that are greater than 'target'
- **Examples:**
```
count_greater [] 5 = 0
count_greater [5] 5 = 0
count_greater [8; 5; 6; 6; 3] 5 = 3
count_greater [1.1; 3.14; 0.01] 2.5 = 1
count_greater ['e'; 'c'; 'b'; 'a'; 'd'] 'b' = 3
```

#### greater_tuple lst
- **Type**: `'a list -> ('a * int) list`
- **Description**: Given a list, returns a list of pairs where the first integer represents the element of the list and the second integer represents the number of elements in the list that are greater than the first integer in the tuple.
- **Examples:**
```
greater_tuple [] = []
greater_tuple [1] = [(1,0)]
greater_tuple [1; 2; 2; 1; 3] = [(1,3); (2,1); (2,1); (1,3); (3,0)]
greater_tuple [1.1; 3.14; 2.5; 0.01] = [(1.1,2); (3.14,0); (2.5,1); (0.01,3)]
greater_tuple ['a'; 'c'; 'c'; 'r'; 'q'] = [('a',4); ('c',2); ('c',2); ('r',0); ('q',1)]
```

#### flat_pair lst
- **Type**: `('a * 'a) list -> 'a list`
- **Description**: Pulls the elements out of the input pairs and smushes them all into one list.
- **Examples:**
```
flat_pair [(1,2);(3,4)] = [1;2;3;4]
flat_pair [("apple","orange");("tomato","lettuce")] = ["apple";"orange";"tomato";"lettuce"]
flat_pair [(true, false)] = [true;false]

```

#### rm lst target
- **Type**: `'a list -> 'a -> 'a list`
- **Description**: Removes all values that are **greater** than 'target' in 'lst'.
- **Examples:**
```
rm [] 1 = []
rm [2] 2 = [2]
rm [1; 3; 2] 5 = [1; 3; 2]
rm [1; 3; 1; 2] 1 = [1; 1]
rm [1.1; 3.14; 0.01; 2.5] 1.1 = [1.1; 0.01]
rm ['c'; 'z'; 'b'; 'v'; 'e'] 'n' = ['c'; 'b'; 'e']

```

## Part 2: Integer BST
The remaining sections will be implemented in `data.ml`.

Here, you will write functions that will operate on a binary search tree whose nodes contain integers. Provided below is the type of `int_tree`.

```
type int_tree =
    IntLeaf
  | IntNode of int_tree * int_tree * int
```

According to this definition, an ``int_tree`` is either: empty (just a leaf), or a node (containing a left subtree, right subtree, and an int). An empty tree is just a leaf.

```
let empty_int_tree = IntLeaf
```

Like lists, BSTs are immutable. Once created we cannot change it. To insert an element into a tree, create a new tree that is the same as the old, but with the new element added. Let's write `insert` for our `int_tree`. Recall the algorithm for inserting element `x` into a tree:

- *Empty tree?* Return a single-node tree.
- `x` *less than the current node?* Return a tree that has the same content as the present tree but where the left subtree is instead the tree that results from inserting `x` into the original left subtree.
- `x` *already in the tree?* Return the tree unchanged.
- `x` *greater than the current node?* Return a tree that has the same content as the present tree but where the right subtree is instead the tree that results from inserting `x` into the original right subtree.

Here's one implementation:

```
let rec int_insert x t =
  match t with
    IntLeaf -> IntNode (IntLeaf, IntLeaf, x)
  | IntNode (l, r, y) when x < y -> IntNode (int_insert x l, r, y)
  | IntNode (l, r, y) when x = y -> t
  | IntNode (l, r, y) -> IntNode (l, int_insert x r, y)
```

**Note**: The `when` syntax may be unfamiliar to you - it acts as an extra guard in addition to the pattern. For example, `IntNode (l, r, y) when x < y` will only be matched when the tree is an `IntNode` and `x < y`. This serves a similar purpose to having an if statement inside of the general `IntNode` match case, but allows for more readable syntax in many cases.

Let's try writing a function which determines whether a tree contains an element. This follows a similar procedure except we'll be returning a boolean if the element is a member of the tree.

```
let rec int_mem x t =
  match t with
    IntLeaf -> false
  | IntNode (l, r, y) when x < y -> int_mem x l
  | IntNode (l, r, y) when x = y -> true
  | IntNode (l, r, y) -> int_mem x r
```

It's your turn now! Write the following functions which operate on `int_tree`.

**Note**: To the observant reader, once again we're implementing an abstract Set, but this time using a BST.  A BST is just one implementation of a set, as we saw in P2a you can implement an abstract Set using Lists in OCaml, which is just a Linked list under the hood.

#### int_size t
- **Type**: `int_tree -> int`
- **Description**: Returns the number of nodes in tree `t`.
- **Examples:**
```
int_size empty_int_tree = 0
int_size (int_insert 1 (int_insert 2 empty_int_tree)) = 2
```

#### int_max t
- **Type**: `int_tree -> int`
- **Description**: Returns the maximum element in tree `t`. Raises exception `Invalid_argument("int_max")` on an empty tree. This function should be O(height of the tree).
- **Examples:**
```
int_max (int_insert_all [1;2;3] empty_int_tree) = 3
```

#### int_insert_all lst t
- **Type**: `int list -> int_tree -> int_tree`
- **Description**: Returns a tree which is the same as tree `t`, but with all the integers in list `lst` added to it. Try to use fold to implement this in one line.
- **Examples:**
```
int_as_list (int_insert_all [1;2;3] empty_int_tree) = [1;2;3]
```

#### int_as_list t
- **Type**: `int_tree -> int list`
- **Description**: Returns a list where the values correspond to an [in-order traversal][wikipedia inorder traversal] on tree `t`.
- **Examples:**
```
int_as_list (int_insert 2 (int_insert 1 empty_int_tree)) = [1;2]
int_as_list (int_insert 2 (int_insert 2 (int_insert 3 empty_int_tree))) = [2;3]
```

## Part 3: Polymorphic BST
Our type `int_tree` is limited to integer elements. We want to define a binary search tree over *any* totally ordered type. Let's define the type `'a atree` to do so.

```
type 'a atree =
    Leaf
  | Node of 'a * 'a atree * 'a atree
```

This defintion is the same as `int_tree` except it's polymorphic. The nodes may contain any type `'a`, not just integers. Since a tree may contain any value, we need a way to compare values. We define a type for comparison functions.

```
type 'a compfn = 'a -> 'a -> int
```

Any comparison function will take two `'a` values and return an integer. If the integer is negative, the first value is less than the second; if positive, the first value is greater; if 0 they're equal.

Finally, we can bundle the two previous types to create a polymorphic BST.

```
type 'a ptree = 'a compfn * 'a atree
```

An empty tree is just a leaf and some comparison function.

```
let empty_ptree f : 'a ptree = (f, Leaf)
```

You can modify the code from your `int_tree` functions to implement some functions on `ptree`. Remember to use the bundled comparison function!

#### pinsert x t
- **Type**: `'a -> 'a ptree -> 'a ptree`
- **Description**: Returns a tree which is the same as tree `t`, but with `x` added to it.
- **Examples:**
```
let int_comp x y = if x < y then -1 else if x > y then 1 else 0
let t0 = empty_ptree int_comp
let t1 = pinsert 1 (pinsert 8 (pinsert 5 t0))
let pt_comp (x1, y1) (x2, y2) = if int_comp x1 x2 = 0 then int_comp y1 y2 else int_comp x1 x2
let pt0 = empty_ptree pt_comp
let pt1 = pinsert (2, 0) (pinsert (5, 2) (pinsert (3, 1) pt0))
```

#### pmem x t
- **Type**: `'a -> 'a ptree -> bool`
- **Description**: Returns true iff `x` is an element of tree `t`.
- **Examples:**
```
(* see definitions of t0 and t1 above *)
pmem 5 t0 = false
pmem 5 t1 = true
pmem 1 t1 = true
pmem 2 t1 = false
pmem (2, 0) pt1 = true
```

#### pinsert_all lst t
- **Type**: `'a list -> 'a ptree -> 'a ptree`
- **Description**: Returns a tree which is the same as tree `t`, but with all the elements in list `lst` added to it. Try to use fold to implement this in one line.
- **Examples:**
```
p_as_list (pinsert_all [1;2;3] t0) = [1;2;3]
p_as_list (pinsert_all [1;2;3] t1) = [1;2;3;5;8]
```

#### p_as_list t
- **Type**: `'a ptree -> 'a list`
- **Description**: Returns a list where the values correspond to an [in-order traversal][wikipedia inorder traversal] on tree `t`.
- **Examples:**
```
p_as_list (pinsert 2 (pinsert 1 t0)) = [1;2]
p_as_list (p_insert 2 (p_insert 2 (p_insert 3 t0))) = [2;3]
p_as_list pt1 = [(2, 0); (3, 1); (5, 2)]
```

#### pmap f t
- **Type**: `('a -> 'a) -> 'a ptree -> 'a ptree`
- **Description**: Returns a tree where the function `f` is applied to all the elements of `t`.
- **Examples:**
```
p_as_list (pmap (fun x -> x * 2) t1) = [2;10;16]
p_as_list (pmap (fun x -> x * (-1)) t1) = [-8;-5;-1]
p_as_list (pmap (fun (x, y) -> (x + 2, y - 3)) pt1) = [(4, -3); (5, -2); (7, -1)]
```

Part 4: Graphs with Records
--------------------------------------
For the last part of this project, you will implement functions which operate on directed graphs.

Here are the types for graphs. They use OCaml's record syntax.

```
type node = int
type edge = { src: node; dst: node; }
type graph = { nodes: int_tree; edges: edge list }
```

A graph is record with two fields: a set of nodes aptly called "nodes" (represented as an `int_tree`), and a list of edges. A node is represented as an integer, and an edge is a record identifying its source and destination nodes.

An empty graph has no nodes (i.e., the empty integer tree) and has no edges (the empty list).

```
let empty_graph = { nodes = empty_int_tree; edges = [] }
```

Provided below is a function which adds an edge to a graph. Its type is `edge -> graph -> graph`.

```
let add_edge e { nodes = ns; edges = es } =
  let { src = s; dst = d } = e in
  let ns' = int_insert s ns in
  let ns'' = int_insert d ns' in
  let es' = e::es in
  { nodes = ns''; edges = es' }
```

Given an edge `e` and graph `g`, it returns a new graph that is the same as `g`, but with `e` added. Note this routine makes no attempt to eliminate duplicate edges; these could add some inefficiency, but should not harm correctness.

We also provide a function `add_edges : edge list -> graph -> graph` to add multiple edges at once.

Write the following functions which operate on `graph`. You can assume that the graph value these functions receive is only created by graph functions themselves in your solution. In other words, you can assume that any invariants about the graph data structure that are enforced by your code will be satisfied — we will not build graph values from scratch.

#### graph_empty g
- **Type**: `graph -> bool`
- **Description**: Returns true iff graph `g` is empty.
- **Examples:**
```
graph_empty (add_edge { src = 1; dst = 2 } empty_graph) = false
graph_empty empty_graph = true
```

#### graph_size g
- **Type**: `graph -> int`
- **Description**: Returns the number of nodes in graph `g`.
- **Examples:**
```
graph_size (add_edge { src = 1; dst = 2 } empty_graph) = 2
graph_size (add_edge { src = 1; dst = 1 } empty_graph) = 1
```

#### is_dst n e
- **Type**: `node -> edge -> bool`
- **Description**: Returns true iff node `n` is the destination of edge `e`.
- **Examples:**
```
is_dst 1 { src = 1; dst = 2 } = false
is_dst 2 { src = 1; dst = 2 } = true
```

#### src_edges n g
- **Type**: `node -> graph -> edge list`
- **Description**: Returns a list of edges in graph `g` whose source node is `n`.
- **Examples:**
```
src_edges 1 (add_edges [{src=1;dst=2}; {src=1;dst=3}; {src=2;dst=2}] empty_graph) = [{src=1;dst=2}; {src=1;dst=3}]
```

#### reachable n g
- **Type**: `node -> graph -> int_tree`
- **Description**: Returns the set of nodes reachable from node `n` in graph `g`, where the set is represented as an `int_tree`. If `n` is neither a source nor a destination in the graph, `IntLeaf` should be returned.
- **Examples:**
```
int_as_list
 (reachable 1
   (add_edges [{src=1;dst=2}; {src=1;dst=3}; {src=2;dst=2}] empty_graph)) =
   [1;2;3]

int_as_list
 (reachable 3
   (add_edges [{src=1;dst=2}; {src=1;dst=3}; {src=2;dst=2}] empty_graph)) =
   [3]

int_as_list
 (reachable 2
   (add_edges [{src=0;dst=1}] empty_graph)) =
   []
```

## Academic Integrity
Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

[pervasives doc]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/Pervasives.html
[git instructions]: ../git_cheatsheet.md
[wikipedia inorder traversal]: https://en.wikipedia.org/wiki/Tree_traversal#In-order
[submit server]: submit.cs.umd.edu
[web submit link]: image-resources/web_submit.jpg
[web upload example]: image-resources/web_upload.jpg
