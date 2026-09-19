open! Core

type t =
  | Buy
  | Sell
[@@deriving compare, equal, sexp, enumerate]

val opposite : t -> t
