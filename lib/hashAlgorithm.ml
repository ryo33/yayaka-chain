type t =
  | SHA1
  | SHA2

let from_string = function
  | "SHA-1" -> Some SHA1
  | "SHA-2" -> Some SHA2
  | _ -> None

let to_string = function
  | SHA1 -> "SHA-1"
  | SHA2 -> "SHA-2"
