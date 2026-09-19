open! Core

type tif =
  | GTC
  | IOC
  | FOK
[@@deriving compare, equal, sexp_of]

type t =
  | Limit of
      { price : Price.t
      ; tif : tif
      ; post_only : bool
      }
  | Market
[@@deriving compare, equal, sexp_of]
