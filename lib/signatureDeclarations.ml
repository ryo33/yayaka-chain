open Core

type t = SignatureDeclaration.t list

let format declarations =
  Printf.sprintf "%d\n%s"
  (List.length declarations)
  (List.map declarations ~f:SignatureDeclaration.format |> String.concat ~sep:"\n")
