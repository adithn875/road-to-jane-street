open! Core
open Lob_types

let%expect_test "Order_id accepts non-negative ints only" =
  print_s [%sexp (Order_id.of_int 0 : Order_id.t option)];
  [%expect {| (0) |}];
  print_s [%sexp (Order_id.of_int 7 : Order_id.t option)];
  [%expect {| (7) |}];
  print_s [%sexp (Order_id.of_int (-1) : Order_id.t option)];
  [%expect {| () |}]
;;

let%expect_test "Account_id accepts non-negative ints only" =
  print_s [%sexp (Account_id.of_int 3 : Account_id.t option)];
  [%expect {| (3) |}];
  print_s [%sexp (Account_id.of_int (-1) : Account_id.t option)];
  [%expect {| () |}]
;;

let%expect_test "Order_id works as a map key and stays ordered" =
  let m =
    Order_id.Map.of_alist_exn [ Order_id.of_int_exn 2, "b"; Order_id.of_int_exn 1, "a" ]
  in
  print_s [%sexp (m : string Order_id.Map.t)];
  [%expect {| ((1 a) (2 b)) |}]
;;

let%expect_test "to_int round-trips" =
  printf "%d\n" (Order_id.to_int (Order_id.of_int_exn 42));
  [%expect {| 42 |}]
;;

let%expect_test "of_int_exn raises on negatives" =
  (try ignore (Order_id.of_int_exn (-1) : Order_id.t) with
   | exn -> print_s [%sexp (exn : exn)]);
  [%expect {| ("Order_id.of_int_exn: negative" (n -1)) |}]
;;
