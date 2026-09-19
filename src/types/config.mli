open! Core

(** What to do when an incoming order would trade against a resting order of
    the same account. See rule M-13 in docs/matching-spec.md. *)
type stp_mode =
  | Cancel_newest
  | Cancel_oldest
  | Cancel_both
  | Decrement
[@@deriving compare, equal, sexp_of]

(** Market rules. [private]: fields can be read but a value can only be built
    through [create], which checks that the rules make sense. *)
type t = private
  { tick_size : int
  ; lot_size : int
  ; min_qty : Qty.t
  ; max_qty : Qty.t
  ; band_lo : Price.t
  ; band_hi : Price.t
  ; max_notional : int
  ; stp_mode : stp_mode
  }
[@@deriving sexp_of]

val create
  :  tick_size:int
  -> lot_size:int
  -> min_qty:Qty.t
  -> max_qty:Qty.t
  -> band_lo:Price.t
  -> band_hi:Price.t
  -> max_notional:int
  -> stp_mode:stp_mode
  -> t Or_error.t

(** A permissive config for tests and simulations. *)
val default : t
