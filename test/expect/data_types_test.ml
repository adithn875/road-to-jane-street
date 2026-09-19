open! Core
open Lob_types

let oid n = Order_id.of_int_exn n
let px n = Price.of_ticks_exn n
let q n = Qty.of_lots_exn n

let%expect_test "reject reasons list" =
  printf "%d\n" (List.length Reject_reason.all);
  [%expect {| 11 |}]
;;

let%expect_test "order kinds print readably" =
  print_s
    [%sexp
      (Order_kind.Limit { price = px 100; tif = GTC; post_only = false } : Order_kind.t)];
  [%expect {| (Limit (price 100) (tif GTC) (post_only false)) |}];
  print_s [%sexp (Order_kind.Market : Order_kind.t)];
  [%expect {| Market |}]
;;

let%expect_test "commands print readably" =
  print_s [%sexp (Command.Cancel { order_id = oid 7 } : Command.t)];
  [%expect {| (Cancel (order_id 7)) |}];
  let o : New_order.t =
    { id = oid 1
    ; account = Account_id.of_int_exn 9
    ; side = Buy
    ; qty = q 10
    ; kind = Market
    }
  in
  print_s [%sexp (Command.New o : Command.t)];
  [%expect {| (New ((id 1) (account 9) (side Buy) (qty 10) (kind Market))) |}]
;;

let%expect_test "events print readably" =
  print_s [%sexp (Event.Accepted { seq = 1; order_id = oid 1 } : Event.t)];
  [%expect {| (Accepted (seq 1) (order_id 1)) |}];
  print_s
    [%sexp
      (Event.Rejected { seq = 2; order_id = oid 5; reason = Duplicate_order_id }
       : Event.t)];
  [%expect {| (Rejected (seq 2) (order_id 5) (reason Duplicate_order_id)) |}];
  print_s
    [%sexp
      (Event.Cancelled
         { seq = 4; order_id = oid 1; remaining = q 3; cause = Ioc_remainder }
       : Event.t)];
  [%expect {| (Cancelled (seq 4) (order_id 1) (remaining 3) (cause Ioc_remainder)) |}]
;;

let%expect_test "equal distinguishes different events" =
  let a = Event.Accepted { seq = 1; order_id = oid 1 } in
  let b = Event.Accepted { seq = 2; order_id = oid 1 } in
  printf "%b %b\n" (Event.equal a a) (Event.equal a b);
  [%expect {| true false |}]
;;
