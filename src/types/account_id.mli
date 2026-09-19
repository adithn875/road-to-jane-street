open! Core

(** Account identifier. Non-negative. Abstract so it cannot be confused with an
    [Order_id.t] or a plain int. *)
type t [@@deriving hash, sexp]

include Comparable.S with type t := t

val of_int : int -> t option
val of_int_exn : int -> t
val to_int : t -> int
