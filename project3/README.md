# Project 3: SmallC Interpreter

CMSC 330, Spring 2019

Due March 14th at 11:59pm (Late: March 15th at 11:59pm)

P/R/S: 50/50/0

### Ground Rules and Extra Info

This is **NOT** a pair project. You must work on this project alone as with most other CS projects. See the Academic Integrity section for more information. In your code, you may use **any** non-imperative standard library functions (with the exception of printing, see below), but the ones that will be useful to you will be found in the [`Pervasives` module][pervasives doc] and the [`List` module][list doc]. Note that the `List` module has been disallowed in previous projects, but in the case of this project and projects going forward it will be allowed. You may not use any imperative structures of OCaml such as references or the `Hashtbl` module.

To begin this project, you will need to commit any uncommitted changes to your local branch and pull updates from the git repository. [Click here for directions on working with the Git repository.][git instructions]

## 1. Overview

In this project, you will implement a **definitional interpreter** (_aka_ an **evaluator**) for SmallC, a small C-like language. The language contains variables, integer and boolean types, equality and comparison operations, math and boolean operations, simple control flow, and printing (but no input statements).

Recall [from class][lecture notes] that a definitional interpreter is a function that takes a program's *abstract syntax tree* (AST) and evaluates it to its final result. For SmallC, this final result is an *environment*, which is a map from variables to their (current) values. SmallC's AST is defined by the type `stmt`, and environments are defined by the type `environment` in the file [`smallCTypes.ml`][src/smallCTypes.ml]. Your job will be to implement the function

`eval_stmt : environment -> stmt -> environment`

which will evaluate the given statement (second argument) starting with the given environment (first argument), producing the final environment. Since statements also include (arithmetic and other) expressions, you will also implement the function

`eval_expr : environment -> expr -> value`

This function evalutes the given expression to its final value in the given environment. **Both of your functions will go in the file [`eval.ml`][src/eval.ml]; you should not modify any [other files](#project-files-summary) that are given to you.**

## 2. [`smallCTypes.ml`][src/smallCTypes.ml]: Abstract Syntax Trees, Environments, Values

As mentioned above, the SmallC AST is defined by the type `stmt`. This type has the following definition:

```
type stmt =
  | NoOp
  | Seq of stmt * stmt
  | Declare of data_type * string
  | Assign of string * expr
  | If of expr * stmt * stmt
  | DoWhile of stmt * expr
  | While of expr * stmt
  | Print of expr
```

Each part of this datatype corresponds to a kind of SmallC statement. For example, `NoOp` is an empty statement. `Assign of string * expr` corresponds to an assignment statement, where the `string` part indicates a variable name, and the `expr` part indicates the expression whose value should be assigned to the variable. `Seq of stmt * stmt` is a statement that is itself a pair of other statements, with the first executed before the second. We explain this AST in detail in the next section. Note that the types `expr` and `data_type` are part of the SmallC AST, too; they are referenced in `stmt`'s definition above. 

Recall [from class][lecture notes] that in a full-fledged interpreter, a *parser* is used to convert a normal text file into its corresponding AST.  In this project, we provide a parser for you (as discussed more in Section 4). For example, consider the following input file:

```
int main() {
int x;
x = 2 * 3 ^ 5 + 4;
printf(x > 100);
}
```

The parser will take this and produce the following `stmt`:

```
Seq(Declare(Int_Type, "x"),
  Seq(Assign("x",Add(Mult(Int(2), Pow(Int(3), Int(5))), Int(4))),
    Seq(Print(Greater(ID("x"), Int(100))),
      NoOp)))
```

This `stmt` uses `Seq` to string together each of the statements in the body of `main`, one for each line conclusing with `NoOp`. The `Declare(Int_Type, "x")` part corresponds to the first line `int x`. The `Assign("x",Add(Mult(Int(2), Pow(Int(3), Int(5))), Int(4)))` corresponds to the second line `x = 2 * 3 ^ 5 + 4`. And so on.

We suggest before coding you look at the SmallC input examples in [**test/public_inputs**][test/public_inputs/]. You should be able to get a sense of how these examples correspond to the `stmt` type above.

Also in `smallCTypes.ml` are the definitions of type `value` and `environment`. The former is the result from evaluating an expression (i.e., something of type `exp`). The latter is a map from variables to values; it keeps track of the current value assigned to a given variable. Here are their definitions:

```
type value =
  | Int_Val of int
  | Bool_Val of bool
type environment = (string * value) list
```

A value (the result of evaluating an expression) is either an integer or a boolean. An environment is a list of pairs, where the first element is a variable name and the second is its current value. This representation is called an *association list* - the first element of the pair is associated with the second. Elements earlier in the list override elements later in the list.  **The [`List` module][list doc] has many useful functions for working with association lists** which you should consider using in your implementation.

## 3. [`eval.ml`][src/eval.ml]: The Evaluator

To implement the definitional interpreter (i.e., the *evaluator*) you must implement two functions, `eval_expr` and `eval_stmt` in the file [`eval.ml`][src/eval.ml]. **This is the only file you should modify.**

`eval_stmt : environment -> stmt -> environment`

`eval_expr : environment -> expr -> value`

(These signatures are also found in [`eval.mli`][src/eval.mli].)

Each of these takes as an argument an `environment`. Evaluating a statement might modify an environment (e.g., due to a variable assignment), so `eval_stmt` produces an `environment` as output. Evaluating an expression will never change the environment, and so `eval_expr` only produces the final value. Both take an environment as input in which the evaluator can look up current values of variables.

To see these functions in action, to give you a sense of what they do, consider some elements from our example SmallC program in Section 2, above.

First, consider `Add(Mult(Int(2), Pow(Int(3), Int(5))), Int(4))`, an `expr` that represents a SmallC expression. If we evaluate it in an empty environment `[]` we should get `Int_Val 490`. That is, `eval_expr [] (Add(Mult(Int(2), Pow(Int(3), Int(5))), Int(4))) = Int_Val 490`. 

Now, consider `Assign("x",Add(Mult(Int(2), Pow(Int(3), Int(5))), Int(4)))`, a `stmt` that represents a SmallC statement. If we evaluate it in an empty environment, we will get an output environment where `x` maps to `Int_Val 490`. That is, `eval_stmt [] Assign("x",Add(Mult(Int(2), Pow(Int(3), Int(5))), Int(4))) = [("x",Int_Val 490)]`. 

Now consider `Greater(ID("x"), Int(100))` and evaluating it in the environment produced above. We would have `eval_expr [("x",Int_Val 490)] (Greater(ID("x"), Int(100))) = Bool_Val true`; i.e., 490 is indeed greater than 100. 

Finally, if we printed the result of above expression (per the last line of the whole program example above) then "true" would be printed to the console.

### 3.1.  Formal Semantics

In what follows, we will step through each of the variants of the `expr` and `stmt` types to say what your interpreter should do with them. Since our description is in English, which can sometimes be ambiguous, we have also provided a *formal operational semantics* of SmallC in [`semantics.pdf`][semantics document]. We recommend you reference it, not least to become more familiar with the use of operational semantics in practice.

Note that the semantics does not define what to do with error cases such as addition between a boolean and an integer and therefore represent a stuck reduction. The expected behavior for these irreducible error cases are defined only in this document and can be boiled down to the following rules:
- Any expression containing division by zero should raise a DivByZero error when evaluated.
- Any expression or statement that is applied to the wrong types should raise a `TypeError` exception when evaluated, for example, the expression `1 + true` would result in `TypeError`.
- An expression or statement that redefines an already defined variable, assigns to an undefined variable, or reads from an undefined variable should raise a `DeclareError` when evaluated.

We do not enforce what messages you use when raising the `TypeError` or `DeclareError` exceptions; that's up to you. Evaluation of subexpressions should be done from left to right, as specified by the semantics, in order to ensure that lines with multiple possible errors match up with our expected errors.

### 3.2. Function 1: eval_expr

`eval_expr` takes an environment `env` and an expression `e` and produces the result of _evaluating_ `e`, which is something of type `value` (`Int_Val` or `Bool_Val`). Here's what to do with each element of the `expr` type:

#### Int

Integer literals evaluate to a `Int_Val` of the same value.

#### Bool

Boolean literals evaluate to a `Bool_Val` of the same value.

#### ID

An identifier evaluates to whatever value it is mapped to by the environment. Should raise a `DeclareError` if the identifier has no binding.

#### Add, Sub, Mult, Div, and Pow

*These rules are jointly classified as BinOp-Int in the formal semantics.*

These mathematical operations operate only on integers and produce a `Int_Val` containing the result of the operation. All operators must work for all possible integer values, positive or negative, except for division, which will raise a `DivByZeroError` exception on an attempt to divide by zero. If either argument to one of these operators evaluates to a non-integer, a `TypeError` should be raised.

#### Or and And

*These rules are jointly classified as BinOp-Bool in the formal semantics.*

These logical operations operate only on booleans and produce a `Bool_Val` containing the result of the operation. If either argument to one of these operators evaluates to a non-boolean, a `TypeError` should be raised.

#### Not

The unary not operator operates only on booleans and produces a `Bool_Val` containing the negated value of the contained expression. If the expression in the `Not` is not a boolean (and does not evaluate to a boolean), a `TypeError` should be raised.

#### Greater, Less, GreaterEqual, LessEqual

*These rules are jointly classified as BinOp-Int in the formal semantics*

These relational operators operate only on integers and produce a `Bool_Val` containing the result of the operation. If either argument to one of these operators evaluates to a non-integer, a `TypeError` should be raised.

#### Equal and NotEqual

These equality operators operate both on integers and booleans, but both subexpressions must be of the same type. The operators produce a `Bool_Val` containing the result of the operation. If the two arguments to these operators do not evaluate to the same type (i.e. one boolean and one integer), a `TypeError` should be raised.

### 3.3. Function 2: eval_stmt

`eval_stmt` takes an environment `env` and a statement `s` and produces an updated `environment` (defined in Types) as a result. This environment is represented as `a` in the formal semantics, but will be referred to as the environment in this document.

#### NoOp

`NoOp` is short for "no operation" and should do just that - nothing at all. It is used to terminate a chain of sequence statements, and is much like the empty list in OCaml in that way. The environment should be returned unchanged when evaluating a `NoOp`.

#### Seq

The sequencing statement is used to compose whole programs as a series of statements. When evaluating `Seq`,  evaluate the first substatement under the environment `env` to create an updated environment `env'`. Then, evaluate the second substatement under `env'`, returning the resulting environment.

#### Declare

The declaration statement is used to create new variables in the environment. If a variable of the same name has already been declared, a `DeclareError` should be raised. Otherwise, if the type being declared is `Int_Type`, a new binding to the value `Int_Val(0)` should be made in the environment. If the type being declared is `Bool_Type`, a new binding to the value `Bool_Val(false)` should be made in the environment. The updated environment should be returned.

#### Assign

The assignment statement assigns new values to already-declared variables. If the variable hasn't been declared before assignment, a `DeclareError` should be raised. If the variable has been declared to a different type than the one being assigned into it, a `TypeError` should be raised. Otherwise, the environment should be updated to reflect the new value of the given variable, and an updated environment should be returned.

#### If

The `if` statement consists of three components - a guard expression, an if-body statement and an else-body statement. The guard expression must evaluate to a boolean - if it does not, a `TypeError` should be raised. If it evaluates to true, the if-body should be evaluated. Otherwise, the else-body should be evaluated instead. The environment resulting from evaluating the correct body should be returned.

#### While

The while statement consists of two components - a guard expression and a body statement. The guard expression must evaluate to a boolean - if it does not, a `TypeError` should be raised. If it evaluates to `true`, the body should be evaluated to produce a new environment and the entire loop should then be evaluated again under this new environment, returning the environment produced by the reevaluation. If the guard evaluates to `false`, the current environment should simply be returned.

*The formal semantics rule for while loops is particularly helpful!*

#### DoWhile

The do-while statement consists of two components - a body statement and a guard expression. The guard expression must evaluate to a boolean - if it does not, a `TypeError` should be raised. The body should be evaluated to produce a new environment, and if the guard expression evaluates to `true` in this new environment, the entire loop should then be evaluated again in the new environment, returning the environment produced by the reevaluation. If the guard evaluates to `false`, the new environment should be returned.

*The formal semantics rule for do-while loops is particularly helpful!*

#### Print

The print statement is your project's access to standard output. First, the expression to `Print` should be evaluated. Integers should print in their natural forms (i.e. printing `Int_Val(10)` should print "10". Booleans should print in plaintext (i.e. printing `Bool_Val(true)` should print "true" and likewise for "false"). Whatever is printed should always be followed by a newline.

**VERY IMPORTANT NOTE ON PRINTING**: Printing should be performed through the following wrapper functions (not the standard `print_int` etc.):
- `print_output_string : string -> unit`
- `print_output_int : int -> unit`
- `print_output_bool : bool -> unit`
- `print_output_newline : unit -> unit`

## 4. Building and Running your Evaluator with our Parser

As discussed in Section 2, a real interpreter has two parts: a *parser*, which takes text files and converts them into an AST, and an evaluator, which runs the AST to produce a final result, print output, etc. Your job has been to implement the evaluator. To help you test this evaluator, we are providing code that will do parsing for you. This code will take in a text file and produce an AST of type `stmt` and then pass it to your `eval_stmt` function. (Since we're doing the parsing, you are not responsible for poorly formed input - if there's a parse error, your code should not be called.)

Our parser expects an input file will have a single `main()` function, whose contents is a statement (or a sequence of statements, which will be parsed as a single `Seq`). The parser will strip the `main` wrapper part, and supply your `eval_stmt` with just the `stmt` body. We suggest before coding you look at the SmallC input examples in **test/public_input**. You should be able to get a sense of how these examples correspond to the `stmt` type above.

### Compilation, Tests, and Running

Public and student tests can be run using the same `dune` command that you used in the previous projects but, this time you need to set the environment variable `OCAMLPATH` before running the command. The exact value of OCAMLPATH will depend on the version of OCaml you are using. If you have version 4.07.1, you can use the following commands verbatim but, if you have 4.07.0 you will need to replace all instances of `dep` with `dep4.07.0`. The full command is now `env OCAMLPATH=dep dune runtest -f`. Setting `OCAMLPATH` tells `dune` where it can find the lexer and parser that we have provided. You will need to provide this environment variable for every `dune` command so you may want to add it to your environment once by running `OCAMLPATH=dep` as separate command before using `dune`. We have also provided a shell script `test.sh` that runs the command given above.

As mentioned in the **Print** case of `eval_stmt` above, our code assumes you will use the printing routines we provide, which will print to the console but also store away results to be tested. Be sure you use them! If the SmallC program being interpreted is valid, we will test if you produce the right sequence of print statements and final environment. If the program is invalid, with a type error or numeric error, we will test if you raise the right exception at the right time. 

As an alternative to running tests, you can run the SmallC interpreter directly on a SmallC program by running `OCAMLPATH=dep dune exec bin/interface.bc -- <filename>`. This driver, provided by us, reads in a program from a file and evaluates the code, outputing the results of any print statements present in the source file. This command is a lot like the `ruby` command, but instead of running the ruby interpreter, it runs the SmallC interpreter that you wrote yourself! This uses the parser that we provide.

If you would like more detailed information about what your code produced, running `env OCAMLPATH=dep dune exec bin/interface.bc -- <filename> -R` provides a report on the resultant variable bindings as reported by your evaluator. If you would like to see data structure that is being generated by the parser and being fed into your interpreter, run `env OCAMLPATH=dep exec bin/interface.bc <filename> -U` and our `Utils` module will translate the data structure into a string and print it out for you - this part does not require any of your code, so feel free to try it on the public tests before you even start! Use the `interface` executable to your advantage when testing; that's why we're providing it! Note that you don't need to touch `interface.ml` yourself, as it only functions as an entry point for the interpreter and is independent of your implementation.

As with running tests, we have provided a shell script `interface.sh` that executes the command given above. 

Project Files Summary
-------------
The following is an overview of the files provided with the project, for your reference:

-  OCaml Files
    - **[src/][src/]**: This directory contains all of the code you should be working with directly.
    - **[src/eval.ml][src/eval.ml]**: All of your code will all be written in the file `eval.ml`. _None of the files other than this one should be changed._
    - **[src/eval.mli][src/eval.mli]**: This is the _interface_ for `eval.ml`. It defines what types and functions are visible to modules outside of `eval.ml`.
    - **[src/smallCTypes.ml][src/smallCTypes.ml]**: This file contains all type definitions used in this project.
    - **[src/evalUtils.ml][src/evalUtils.ml]**: The small part of this file that concerns you in implementing this project is called out very explicitly when it is needed later in the document, otherwise you should not need to look at this file.
    - **[bin/][bin/]**: This directory contains code for a SmallC interface you are given.
    - **[bin/interface.ml][bin/interface.ml]**: We have provided this interface to aid you in testing your program. You should not modify this file. The following section in the document details how you can use the interface.
    - **[test/][test/]**: This directory contains unit tests and related code.
    - **[test/public.ml][test/public.ml]** and **[test/public_inputs/][test/public_inputs/]**: The public test driver file and the SmallC input files to go with it, respectively.
    - **[test/testUtils.ml][test/testUtils.ml]**: Functions written to aid in tests. These functions are used by our test suite and you are encouraged to use them in your own tests.
- Compiled OCaml Files
    - **[dep/parser/][dep/parser/]**: This directory contains a precompiled implementation for a SmallC lexer and parser used for turning plain files into OCaml datatypes. They are precompiled because you will implement  your own parser in a later project.
- Submission Scripts and Other Files
  - **[test.sh][test.sh]** and **[interface.sh][interface.sh]**: Shell script wrappers around dune commands to help you run and test the interpreter.
  - **[submit.rb][submit.rb]**: Execute this script to submit your project to the submit server.
  - **[submit.jar][submit.jar]** and **.submit**: Don't worry about these files, but make sure you have them.

Project Submission
------------------
You should submit the file `eval.ml` containing your solution. You may submit other files, but they will be ignored during grading. We will run your solution as individual OUnit tests just as in the provided public test file.

Be sure to follow the project description exactly! Your solution will be graded automatically, so any deviation from the specification will result in lost points.

You can submit your project in two ways:
- Submit your files directly to the [submit server][submit server] as a zip file by clicking on the submit link in the column "web submission".
Then, use the submit dialog to submit your zip file containing `eval.ml` directly.
Select your file using the "Browse" button, then press the "Submit project!" button. You will need to put it in a zip file since there are two component files.
- Submit directly by executing a the submission script on a computer with Java and network access. Included in this project are the submission scripts and related files listed under **Project Files**. These files should be in the directory containing your project. From there you can either execute submit.rb or run the command `java -jar submit.jar` directly (this is all submit.rb does).

No matter how you choose to submit your project, make sure that your submission is received by checking the [submit server][submit server] after submitting.

Academic Integrity
------------------
Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

<!-- Link References -->
[list doc]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html
[semantics document]: semantics.pdf
[lecture notes]: http://www.cs.umd.edu/class/spring2019/cmsc330/lectures/13-semantics.pdf

<!--project file links-->
[submit.rb]: submit.rb
[src/]: src/
[src/eval.ml]: src/eval.ml
[src/eval.mli]: src/eval.mli
[src/smallCTypes.ml]: src/smallCTypes.ml
[src/evalUtils.ml]: src/evalUtils.ml
[bin/]: bin/
[bin/interface.ml]: bin/interface.ml
[test/]: test/
[test/public.ml]: test/public.ml
[test/public_inputs/]: test/public_inputs/
[test/testUtils.ml]: test/testUtils.ml
[dep/parser/]: dep/parser/
[interface.sh]: interface.sh
[test.sh]: test.sh
[submit.rb]: submit.rb
[submit.jar]: submit.jar

<!-- These should always be left alone or at most updated -->
[pervasives doc]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/Pervasives.html
[git instructions]: ../git_cheatsheet.md
[submit server]: https://submit.cs.umd.edu
[web submit link]: image-resources/web_submit.jpg
[web upload example]: image-resources/web_upload.jpg
