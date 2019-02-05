type t = RSA

let of_string = function
  | "rsa" -> Some RSA
  | _ -> None

let to_string = function
  | RSA -> "rsa"
