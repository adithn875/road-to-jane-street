open! Core

type t =
  { id : Order_id.t
  ; account : Account_id.t
  ; side : Side.t
  ; qty : Qty.t
  ; kind : Order_kind.t
  }
[@@deriving compare, equal, sexp_of]
