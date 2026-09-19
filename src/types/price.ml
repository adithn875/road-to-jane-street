open! Core

type t = int [@@deriving compare, equal, sexp_of]

let of_ticks n = if n > 0 then Some n else None

let of_ticks_exn n =
  match of_ticks n with
  | Some t -> t
  | None -> raise_s [%message "Price.of_ticks_exn: not positive" (n : int)]
;;

let to_ticks t = t
