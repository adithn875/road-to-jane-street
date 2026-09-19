open! Core

module T = struct
  type t = int [@@deriving compare, equal, hash, sexp]
end

include T
include Comparable.Make (T)

let of_int n = if n >= 0 then Some n else None

let of_int_exn n =
  match of_int n with
  | Some t -> t
  | None -> raise_s [%message "Order_id.of_int_exn: negative" (n : int)]
;;

let to_int t = t
