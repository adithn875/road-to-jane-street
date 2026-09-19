open! Core
open Lob_types

let px n = Price.of_ticks_exn n
let q n = Qty.of_lots_exn n

let make
      ?(tick_size = 1)
      ?(lot_size = 1)
      ?(min_qty = q 1)
      ?(max_qty = q 100)
      ?(band_lo = px 1)
      ?(band_hi = px 1000)
      ?(max_notional = 1_000_000)
      ()
  =
  Config.create
    ~tick_size
    ~lot_size
    ~min_qty
    ~max_qty
    ~band_lo
    ~band_hi
    ~max_notional
    ~stp_mode:Config.Cancel_newest
;;

let%expect_test "a sensible config is accepted" =
  printf "%b\n" (Or_error.is_ok (make ()));
  [%expect {| true |}]
;;

let%expect_test "nonsense configs are rejected" =
  let bad =
    [ make ~tick_size:0 ()
    ; make ~lot_size:0 ()
    ; make ~min_qty:(q 10) ~max_qty:(q 5) ()
    ; make ~band_lo:(px 500) ~band_hi:(px 100) ()
    ; make ~max_notional:0 ()
    ; make ~lot_size:10 ~min_qty:(q 5) ()
    ; make ~tick_size:10 ~band_lo:(px 5) ()
    ]
  in
  print_s [%sexp (List.map bad ~f:Or_error.is_error : bool list)];
  [%expect {| (true true true true true true true) |}]
;;

let%expect_test "default config is valid" =
  printf "%d %d\n" Config.default.tick_size Config.default.lot_size;
  [%expect {| 1 1 |}]
;;
