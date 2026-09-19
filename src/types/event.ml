open! Core

type cancel_cause =
  | User
  | Ioc_remainder
  | Stp
[@@deriving compare, equal, sexp_of]

type t =
  | Accepted of
      { seq : int
      ; order_id : Order_id.t
      }
  | Rejected of
      { seq : int
      ; order_id : Order_id.t
      ; reason : Reject_reason.t
      }
  | Trade of
      { seq : int
      ; taker : Order_id.t
      ; maker : Order_id.t
      ; price : Price.t
      ; qty : Qty.t
      ; aggressor : Side.t
      }
  | Cancelled of
      { seq : int
      ; order_id : Order_id.t
      ; remaining : Qty.t
      ; cause : cancel_cause
      }
  | Replaced of
      { seq : int
      ; order_id : Order_id.t
      ; new_qty : Qty.t
      ; new_price : Price.t
      ; lost_priority : bool
      }
  | Book_delta of
      { seq : int
      ; side : Side.t
      ; price : Price.t
      ; new_total_qty : int
      }
[@@deriving compare, equal, sexp_of]
