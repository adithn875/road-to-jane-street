open! Core

type stp_mode =
  | Cancel_newest
  | Cancel_oldest
  | Cancel_both
  | Decrement
[@@deriving compare, equal, sexp_of]

type t =
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

let create
      ~tick_size
      ~lot_size
      ~min_qty
      ~max_qty
      ~band_lo
      ~band_hi
      ~max_notional
      ~stp_mode
  =
  let check cond msg = if cond then Ok () else Or_error.error_string msg in
  Or_error.combine_errors_unit
    [ check (tick_size > 0) "tick_size must be positive"
    ; check (lot_size > 0) "lot_size must be positive"
    ; check (Qty.compare min_qty max_qty <= 0) "min_qty must be <= max_qty"
    ; check (Price.compare band_lo band_hi <= 0) "band_lo must be <= band_hi"
    ; check (max_notional > 0) "max_notional must be positive"
    ; check
        (tick_size > 0 && Int.rem (Price.to_ticks band_lo) tick_size = 0)
        "band_lo must be a multiple of tick_size"
    ; check
        (tick_size > 0 && Int.rem (Price.to_ticks band_hi) tick_size = 0)
        "band_hi must be a multiple of tick_size"
    ; check
        (lot_size > 0 && Int.rem (Qty.to_lots min_qty) lot_size = 0)
        "min_qty must be a multiple of lot_size"
    ; check
        (lot_size > 0 && Int.rem (Qty.to_lots max_qty) lot_size = 0)
        "max_qty must be a multiple of lot_size"
    ]
  |> Or_error.map ~f:(fun () ->
    { tick_size; lot_size; min_qty; max_qty; band_lo; band_hi; max_notional; stp_mode })
;;

let default =
  Or_error.ok_exn
    (create
       ~tick_size:1
       ~lot_size:1
       ~min_qty:(Qty.of_lots_exn 1)
       ~max_qty:(Qty.of_lots_exn 1_000_000)
       ~band_lo:(Price.of_ticks_exn 1)
       ~band_hi:(Price.of_ticks_exn 1_000_000)
       ~max_notional:1_000_000_000_000
       ~stp_mode:Cancel_newest)
;;
