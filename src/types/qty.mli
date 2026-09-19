open! Core

(** A quantity in integer lots. Always strictly positive. See ADR-0002. *)
type t [@@deriving compare, equal, sexp_of]

val of_lots : int -> t option
val of_lots_exn : int -> t
val to_lots : t -> int

(** Overflow is prevented upstream by the validator's notional bound (V-4). *)
val add : t -> t -> t

(** [sub a b] is [Some (a - b)] when [a > b], otherwise [None]. [None] also
    covers "exactly filled", which is how fills signal that nothing remains. *)
val sub : t -> t -> t option

val min : t -> t -> t
