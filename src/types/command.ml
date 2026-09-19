open! Core

type t =
  | New of New_order.t
  | Cancel of { order_id : Order_id.t }
  | Replace of
      { order_id : Order_id.t
      ; new_qty : Qty.t option
      ; new_price : Price.t option
      }
[@@deriving compare, equal, sexp_of]
