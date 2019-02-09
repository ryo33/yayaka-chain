open Core
open HashAlgorithm
open Bos

type t = { algorithm : HashAlgorithm.t; hash : string }

let hash algorithm text =
  let unwrap result =
    result
    |> Result.map ~f:(String.chop_prefix_exn ~prefix:"(stdin)= ")
    |> Result.map ~f:(fun hex -> Hex.to_string (`Hex hex) |> Base64.encode_exn)
    |> Result.map_error ~f:(fun _ -> Failure "")
    |> Result.ok_exn in
  match algorithm with
  | Sha1 ->
    let cmd = Cmd.(v "openssl" % "dgst" % "-sha1" % "-hex") in
    let result = OS.Cmd.(run_io cmd (in_string text) |> to_string) in
    { algorithm = algorithm; hash = unwrap result }
  | Sha256 ->
    let cmd = Cmd.(v "openssl" % "dgst" % "-sha256" % "-hex") in
    let result = OS.Cmd.(run_io cmd (in_string text) |> to_string) in
    { algorithm = algorithm; hash = unwrap result }

let format { algorithm; hash } =
  HashAlgorithm.to_string algorithm ^ "\n" ^ hash
