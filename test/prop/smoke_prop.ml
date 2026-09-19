let%test_unit "list reverse is an involution" =
  QCheck.Test.check_exn
    (QCheck.Test.make ~count:1000 QCheck.(list int) (fun l -> List.rev (List.rev l) = l))
;;
