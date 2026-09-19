open! Core
open Lob_types

let%expect_test "all lists both sides" =
  print_s [%sexp (Side.all : Side.t list)];
  [%expect {| (Buy Sell) |}]
;;

let%expect_test "opposite flips the side" =
  print_s [%sexp (Side.opposite Side.Buy : Side.t)];
  [%expect {| Sell |}];
  print_s [%sexp (Side.opposite Side.Sell : Side.t)];
  [%expect {| Buy |}]
;;

let%expect_test "opposite is an involution" =
  printf
    "%b\n"
    (List.for_all Side.all ~f:(fun s -> Side.equal (Side.opposite (Side.opposite s)) s));
  [%expect {| true |}]
;;
