open Core

type t = { body : BlockBody.t; signatures : Signature.t list }

let format { body; signatures } =
  Printf.sprintf "%s%s\n"
  (BlockBody.format body)
  (List.map signatures ~f:Signature.format |> String.concat ~sep:"\n")

