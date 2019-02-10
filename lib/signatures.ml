open Core

type t = Signature.t list

let format signatures =
  (List.map signatures ~f:Signature.format |> String.concat ~sep:"\n")
