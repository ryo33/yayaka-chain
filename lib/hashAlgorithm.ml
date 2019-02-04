type t =
  | Sha1
  | Sha256

let of_string = function
  | "Sha-1" -> Some Sha1
  | "Sha-2" -> Some Sha256
  | _ -> None

let to_string = function
  | Sha1 -> "Sha-1"
  | Sha256 -> "Sha-2"
