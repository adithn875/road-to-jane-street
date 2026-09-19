open! Core

let%expect_test "toolchain works" =
  print_endline Lob_types.Version.name;
  [%expect {| lob |}]
;;
