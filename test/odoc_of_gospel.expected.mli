[@@@ocaml.text " Module informal documentation "]
[@@@ocaml.text " An axiom declaration "]
[@@@gospel {| axiom a : true |}]
[@@@ocaml.text " A logical function declaration without definition "]
[@@@gospel {| function f : integer -> integer |}]
[@@@ocaml.text " A logical function definition "]
[@@@gospel {| function g (i : integer) : integer = i + 1 |}]
[@@@ocaml.text " A logical function declaration with assertions "]
[@@@gospel
  {| function h (i : integer) : integer = i - 1 |}[@@gospel
                                                    {| requires i > 0
    ensures result >= 0 |}]]
[@@@ocaml.text " A logical predicate definition "]
[@@@gospel {| predicate p (i : integer) = i = 42 |}]
[@@@ocaml.text " A ghost type declaration "]
[@@@gospel {| type casper |}]
type 'a t[@@ocaml.doc " A program type declaration with specifications "]
[@@gospel {| model m : 'a sequence
    invariant true |}]
val prog_fun : int -> int[@@ocaml.doc
                           " A program function with specifications "]
[@@gospel {| y = prog_fun x
    requires true
    ensures true |}]
