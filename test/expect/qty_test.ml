open! Core
open Lob_types

let q n = Qty.of_lots_exn n

let%expect_test "of_lots accepts positives and rejects the rest" =
  print_s [%sexp (Qty.of_lots 5 : Qty.t option)];
  [%expect {| (5) |}];
  print_s [%sexp (Qty.of_lots 0 : Qty.t option)];
  [%expect {| () |}];
  print_s [%sexp (Qty.of_lots (-1) : Qty.t option)];
  [%expect {| () |}]
;;

let%expect_test "sub returns None when nothing would remain" =
  print_s [%sexp (Qty.sub (q 10) (q 4) : Qty.t option)];
  [%expect {| (6) |}];
  print_s [%sexp (Qty.sub (q 4) (q 4) : Qty.t option)];
  [%expect {| () |}];
  print_s [%sexp (Qty.sub (q 4) (q 10) : Qty.t option)];
  [%expect {| () |}]
;;

let%expect_test "add and min" =
  print_s [%sexp (Qty.add (q 3) (q 4) : Qty.t)];
  [%expect {| 7 |}];
  print_s [%sexp (Qty.min (q 3) (q 4) : Qty.t)];
  [%expect {| 3 |}]
;;

let%expect_test "to_lots round-trips" =
  printf "%d\n" (Qty.to_lots (q 9));
  [%expect {| 9 |}]
;;
