# Project 2A: OCaml Warmup

Due: February 22 (Late February 23) at 11:59:59 PM

Points: 30P/34R/36S

## Introduction
The goal of this project is to get you familiar with programming in OCaml. You will have to write a number of small functions, each of which is specified in three sections below.

**This project is due in one week!** We recommend you get started right away, going from top to bottom. The problems get increasingly more challenging, and in many cases later problems can take advantage of earlier solutions.

### Ground Rules
In your code, you may **only** use library functions found in the [`Pervasives` module][pervasives doc]. This means you **cannot** use the List module or any other module. You may **not** use any imperative structures of OCaml such as references. The `@` operator is **not** allowed.

### Project Files
To begin this project, you will need to pull updates from the git repository. [Click here for directions on working with the Git repository.][git instructions] The following are the relevant files:

- OCaml Files
    - **src/basics.ml**: This is where you will write your code for all parts of the project.
    - **src/basics.mli**: This file is used to describe the signature of all the functions in the module. Don't worry about this file, but make sure it exists or your code will not compile.
- Submission Scripts and Other Files
    - **submit.rb**: Execute this script to submit your project to the submit server.
    - **submit.jar** and **.submit**: Don't worry about these files, but make sure you have them.

### Notes on OCaml
OCaml is a lot different than languages you're likely used to working with, and we'd like to point out a few quirks here that may help you work your way out of common issues with the language.

- Some parts of this project are additive, meaning your solutions to earlier functions can be used to aid in writing later functions. Think about this in part 3.
- Unlike most other languages, = in OCaml is the operator for structural equality whereas == is the operator for physical equality. All functions in this project (and in this class, unless ever specified otherwise) are concerned with *structural* equality.
- The subtraction operator (-) also doubles as the negative symbol for `int`s and `float`s in OCaml. As a result, the parser has trouble identifying the difference between subtraction and a negative number. When writing negative numbers, surround them in parentheses. (i.e. `some_function 5 (-10)` works, but `some_function 5 -10` will give an error)

You can run the tests by doing `dune runtest -f`. We recommend you write student tests in `test/student.ml`.

You can run your own tests by doing `dune utop src` (assuming you have `utop`). Then after doing `open Basics` you should be able to use any of the functions.

## Part 1: Simple Functions
Implement the following functions that do not require knowledge of recursion.

#### dup a b c
- **Type**: `'a -> 'a -> 'a -> bool`
- **Description**: Returns true if at least 2 of the inputs are duplicates.
- **Examples:**
```
dup 3 4 5 = false
dup 5 2 5 = true
dup 3 3 3 = true
dup 'a' 'b' 'c' = false
```

#### head_divisor lst
- **Type**: `int list -> bool`
- **Description**: Returns true if the head of `lst` divides the second element of `lst`, false otherwise. We will not test the divide-by-zero case.
- **Examples:**
```
head_divisor [] = false
head_divisor [1] = false
head_divisor [5; 10] = true
head_divisor [2; 4; 7] = true
head_divisor [18; 9] = false
```

#### second_element lst
- **Type**: `int list -> int`
- **Description**: Returns the second element of `lst`, or -1 if `lst` has less than 2 elements.
- **Examples:**
```
second_element [] = -1
second_element [1] = -1
second_element [4; 2] = 2
second_element [4; 6; 9] = 6
```

#### max_first_three lst
- **Type**: `int list -> int`
- **Description**: Returns the maximum of the first three elements of `lst`, the maximum of all elements if `lst` has less than 3 elements, and -1 if the list is empty.
- **Examples:**
```
max_first_three [] = -1
max_first_three [5] = 5
max_first_three [5; 6] = 6
max_first_three [4; 3; 0] = 4
max_first_three [1; 1; 1; 7] = 1
```

## Part 2: Recursive Functions
Implement the following recursive functions.

#### cubes n
- **Type**: `int -> int`
- **Description**: Returns the sum of cubes from 1 to n. If `n` is less than or equal to zero, you should return zero. i.e.
![Sum Of Cubes Image][sum of cubes]
- **Examples:**
```
cubes (-3) = 0
cubes 1 = 1
cubes 3 = 36
cubes 6 = 441
```

#### sum_odd lst
- **Type**: `int list -> int`
- **Description**: Returns the sum of the odd numbers in the list.
- **Examples:**
```
sum_odd [1; 4; 5] = 6
sum_odd [] = 0
sum_odd [4; 8; 6; 1] = 1
```

#### is_even_sum lst
- **Type**: `int list -> bool`
- **Description**: Returns true if the sum of all the elements in the list is even, and false otherwise.
- **Examples:**
```
is_even_sum [1; 2; 3] = true
is_even_sum [] = true
is_even_sum [3; 3; 3] = false
```

#### count_occ lst target
- **Type**: `'a list -> 'a -> int`
- **Description**: Returns the number of occurrences of `target` in `lst`
- **Examples:**
```
count_occ [] 1 = 0
count_occ [1] 1 = 1
count_occ [1; 2; 2; 1; 3] 1 = 2
```

#### dup_list lst
- **Type**: `'a list -> bool`
- **Description**: Returns true if the given list has at least one duplicate element.
- **Examples:**
```
dup_list [1; 1] = true
dup_list [2; 1; 2] = true
dup_list [1; 2] = false
dup_list ["a"; "b"] = false
```

## Part 3: Set Implementation using Lists
For this part of the project, you will implement sets. In practice, sets are implemented using data structures like balanced binary trees or hash tables. However, your implementation must represent sets using lists. While lists don't lend themselves to the most efficient possible implementation, they are much easier to work with.

For this project, we assume that sets are unordered, homogeneous collections of objects without duplicates. The homogeneity condition ensures that sets can be represented by OCaml lists, which are homogeneous. The only further assumptions we make about your implementation are that the empty list represents the empty set, and that it obeys the standard laws of set theory. For example, if we insert an element `x` into a set `a`, then ask whether `x` is an element of `a`, your implementation should answer affirmatively.

Finally, note the difference between a collection and its implementation. Although *sets* are unordered and contain no duplicates, your implementation using lists will obviously store elements in a certain order and may even contain duplicates. However, there should be no observable difference between an implementation that maintains uniqueness of elements and one that does not; or an implementation that maintains elements in sorted order and one that does not.

Depending on your implementation, you may want to re-order the functions you write. Feel free to do so.

If you do not feel so comfortable with sets see the [Set Wikipedia Page][SetWiki] and/or this [Set Operations Calculator][SetOpCalc].

#### insert x a
- **Type**: `'a -> 'a list -> 'a list`
- **Description**: Inserts `x` into the set `a`.
- **Examples:**
```
insert 2 []
insert 3 (insert 2 [])
insert 3 (insert 3 (insert 2 []))
```

#### elem x a
- **Type**: `'a -> 'a list -> bool`
- **Description**: Returns true iff `x` is an element of the set `a`.
- **Examples:**
```
elem 2 [] = false
elem 3 (insert 5 (insert 3 (insert 2 []))) = true
elem 4 (insert 3 (insert 2 (insert 5 []))) = false
```

#### subset a b
- **Type**: `'a list -> 'a list -> bool`
- **Description**: Return true iff `a` **is a** subset of `b`. Formally, A ⊆ B ⇔ ∀x(xϵA ⇒ xϵB).
- **Examples:**
```
subset (insert 2 (insert 4 [])) [] = false
subset (insert 5 (insert 3 [])) (insert 3 (insert 5 (insert 2 []))) = true
subset (insert 5 (insert 3 (insert 2 []))) (insert 5 (insert 3 [])) = false
```

#### eq a b
- **Type**: `'a list -> 'a list -> bool`
- **Description**: Returns true iff `a` and `b` are equal as sets. Formally, A = B ⇔ ∀x(xϵA ⇔ xϵB). (Hint: The subset relation is anti-symmetric.)
- **Examples:**
```
eq [] (insert 2 []) = false
eq (insert 2 (insert 3 [])) (insert 3 []) = false
eq (insert 3 (insert 2 [])) (insert 2 (insert 3 [])) = true
```

#### remove x a
- **Type**: `'a -> 'a list -> 'a list`
- **Description**: Removes `x` from the set `a`.
- **Examples:**
```
elem 3 (remove 3 (insert 2 (insert 3 []))) = false
eq (remove 3 (insert 5 (insert 3 []))) (insert 5 []) = true
```

#### union a b
- **Type**: `'a list -> 'a list -> 'a list`
- **Description**: Returns the union of the sets `a` and `b`. Formally, A ∪ B = {x | xϵA ∨ xϵB}.
- **Examples:**
```
eq (union [] (insert 2 (insert 3 []))) (insert 3 (insert 2 [])) = true
eq (union (insert 5 (insert 2 [])) (insert 2 (insert 3 []))) (insert 3 (insert 2 (insert 5 []))) = true
eq (union (insert 2 (insert 7 [])) (insert 5 [])) (insert 5 (insert 7 (insert 2 []))) = true
```

#### diff a b
- **Type**: `'a list -> 'a list -> 'a list`
- **Description**: Returns the difference of sets `a` and `b`. Formally, A - B = {x | xϵA ∧ ~xϵB}.
- **Examples:**
```
eq (diff (insert 1 (insert 2 [])) (insert 2 (insert 3 []))) (insert 1 []) = true
eq (diff (insert 'a' (insert 'b' (insert 'c' (insert 'd' [])))) (insert 'a' (insert 'e' (insert 'i' (insert 'o' (insert 'u' [])))))) (insert 'b' (insert 'c' (insert 'd' []))) = true
eq (diff (insert "hello" (insert "ocaml" [])) (insert "hi" (insert "ruby" []))) (insert "hello" (insert "ocaml" [])) = true
```

#### cat x a
- **Type**: `'a -> 'b list -> ('a * 'b) list`
- **Description**: Returns the set with each element replaced by a tuple of x and itself.
- **Examples:**
```
eq (cat "z" (insert "a" (insert "b" []))) (insert ("z", "a") (insert ("z", "b") [])) = true
eq (cat 1 []) [] = true
```


## Academic Integrity
Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

[pervasives doc]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/Pervasives.html
[git instructions]: ../git_cheatsheet.md
[submit server]: https://submit.cs.umd.edu
[web submit link]: ../common-images/web_submit.jpg
[web upload example]: ../common-images/web_upload.jpg
[Pythagorean Theorem]: https://en.wikipedia.org/wiki/Pythagorean_theorem
[sum of cubes]: images/sum-of-cubes.png
[Euclidean Algorithm]: https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/the-euclidean-algorithm
[Ackermann–Péter function]:https://en.wikipedia.org/wiki/Ackermann_function
[SetOpCalc]: https://www.mathportal.org/calculators/misc-calculators/sets-calculator.php
[SetWiki]:https://en.wikipedia.org/wiki/Set_(mathematics)#External_links
