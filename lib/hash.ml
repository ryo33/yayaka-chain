open Core
open HashAlgorithm
open Bos

type t = { algorithm : HashAlgorithm.t; hash : string }

let hash algorithm text =
  let unwrap = function
  | Ok result ->
    let hex = String.chop_prefix_exn ~prefix:"(stdin)= " result in
    Hex.to_string (`Hex hex)
  | _ -> raise (Failure "") in
  match algorithm with
  | Sha1 ->
    let cmd = Cmd.(v "openssl" % "dgst" % "-sha1" % "-hex") in
    let result = OS.Cmd.(run_io cmd (in_string text) |> to_string) in
    { algorithm = algorithm; hash = unwrap result }
  | Sha256 ->
    let cmd = Cmd.(v "openssl" % "dgst" % "-sha256" % "-hex") in
    let result = OS.Cmd.(run_io cmd (in_string text) |> to_string) in
    { algorithm = algorithm; hash = unwrap result }
