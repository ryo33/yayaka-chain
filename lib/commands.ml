module YayakaCommand = Command
open Core

type t = YayakaCommand.t list

let format declarations =
  Printf.sprintf "%d\n%s"
  (List.length declarations)
  (List.map declarations ~f:YayakaCommand.format |> String.concat ~sep:"\n")
