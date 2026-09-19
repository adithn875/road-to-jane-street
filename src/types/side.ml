open! Core

type t =
  | Buy
  | Sell
[@@deriving compare, equal, sexp, enumerate]

let opposite = function
  | Buy -> Sell
  | Sell -> Buy
;;
