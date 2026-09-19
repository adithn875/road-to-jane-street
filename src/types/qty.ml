open! Core

type t = int [@@deriving compare, equal, sexp_of]

let of_lots n = if n > 0 then Some n else None

let of_lots_exn n =
  match of_lots n with
  | Some t -> t
  | None -> raise_s [%message "Qty.of_lots_exn: not positive" (n : int)]
;;

let to_lots t = t
let add a b = a + b
let sub a b = if a > b then Some (a - b) else None
let min a b = Int.min a b
