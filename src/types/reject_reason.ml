open! Core

type t =
  | Duplicate_order_id
  | Unknown_order
  | Invalid_tick
  | Invalid_lot
  | Qty_out_of_range
  | Price_outside_band
  | Notional_too_large
  | Would_cross_post_only
  | Fok_not_fully_fillable
  | Self_trade_prevented
  | No_liquidity_market
[@@deriving compare, equal, sexp, enumerate]
