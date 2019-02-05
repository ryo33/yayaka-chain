open Core

type t = RSA

let of_string value =
  let value = String.lowercase value in
  match value with
  | "rsa" -> Some RSA
  | _ -> None

let to_string = function
  | RSA -> "RSA"
