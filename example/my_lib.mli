(** This is a top level module documentation *)

(*@ function silly (x : integer) : integer *)
(*@ axiom really_silly : forall i. silly i = 42 *)

type 'a t
(** Informal documentation fot the type t *)
(*@
  (** t is a container, let's give it two models:
      - one for the size
      - one for the contents *)
  model size : integer
  mutable model contents : 'a Sequence.t *)

(** Let's define a gospel predicate *)

(*@ predicate eq (t0 t1 : 'a t) =
      Sequence.length t0.contents = Sequence.length t1.contents
      /\ forall i.
          0 <= i < Sequence.length t0.contents
          -> Sequence.get t0.contents i = Sequence.get t1.contents i *)

val empty : int -> 'a t
(** build an empty container *)
(*@ t = empty n
    (** Some interleaved informal documentation here *)
    ensures t.size = n
    ensures Sequence.length t.contents = 0 *)

val equal : 'a t -> 'a t -> bool
(*@ b = equal t0 t1
    (** use the gospel predicate here *)
    ensures eq t0 t1 *)

(** Again some informal documentation about the module *)

exception TooMuch

(** this value will have three documentation attributes in the AST *)
val add : 'a -> 'a t -> unit
(** adding an element in place *)
(*@ add a t
    modifies t
    raises TooMuch -> Sequence.length t.contents >= t.size
    ensures Sequence.mem t.contents a *)
