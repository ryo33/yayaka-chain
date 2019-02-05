type t = Sha1 | Sha256

let of_string = function
  | "sha1" -> Some Sha1
  | "sha256" -> Some Sha256
  | _ -> None

let to_string = function
  | Sha1 -> "sha1"
  | Sha256 -> "sha256"
