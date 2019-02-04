open Core
open HashAlgorithm
open Bos

type t = { algorithm : HashAlgorithm.t; hash : string }

let hash hashAlgorithm text =
  let unwrap = function
  | Ok result ->
    String.chop_prefix_exn ~prefix:"(stdin)= " result
  | _ -> raise (Failure "") in
  match hashAlgorithm with
  | Sha1 ->
    let cmd = Cmd.(v "openssl" % "dgst" % "-sha1" % "-hex") in
    let result = OS.Cmd.(run_io cmd (in_string text) |> to_string) in
    unwrap result
  | Sha256 ->
    let cmd = Cmd.(v "openssl" % "dgst" % "-sha256" % "-hex") in
    let result = OS.Cmd.(run_io cmd (in_string text) |> to_string) in
    unwrap result
