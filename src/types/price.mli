open! Core

(** A price in integer ticks. Always strictly positive. See ADR-0002. *)
type t [@@deriving compare, equal, sexp_of]

(** [None] unless the argument is strictly positive. *)
val of_ticks : int -> t option

(** Raises if the argument is not strictly positive. For tests and literals. *)
val of_ticks_exn : int -> t

val to_ticks : t -> int
