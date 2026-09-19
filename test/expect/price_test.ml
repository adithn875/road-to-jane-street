open! Core
open Lob_types

let%expect_test "of_ticks accepts positive values" =
  print_s [%sexp (Price.of_ticks 1 : Price.t option)];
  [%expect {| (1) |}];
  print_s [%sexp (Price.of_ticks 100 : Price.t option)];
  [%expect {| (100) |}]
;;

let%expect_test "of_ticks rejects zero and negatives" =
  print_s [%sexp (Price.of_ticks 0 : Price.t option)];
  [%expect {| () |}];
  print_s [%sexp (Price.of_ticks (-5) : Price.t option)];
  [%expect {| () |}];
  print_s [%sexp (Price.of_ticks Int.min_value : Price.t option)];
  [%expect {| () |}]
;;

let%expect_test "to_ticks round-trips" =
  let p = Price.of_ticks_exn 42 in
  printf "%d\n" (Price.to_ticks p);
  [%expect {| 42 |}]
;;

let%expect_test "compare orders by ticks" =
  let a = Price.of_ticks_exn 1 in
  let b = Price.of_ticks_exn 2 in
  printf "%b %b %b\n" (Price.compare a b < 0) (Price.compare b a > 0) (Price.equal a a);
  [%expect {| true true true |}]
;;

let%expect_test "of_ticks_exn raises on invalid input" =
  (try ignore (Price.of_ticks_exn 0 : Price.t) with
   | exn -> print_s [%sexp (exn : exn)]);
  [%expect {| ("Price.of_ticks_exn: not positive" (n 0)) |}]
;;
