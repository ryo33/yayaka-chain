open Core
open Bos

type t = {
  hash_algorithm : HashAlgorithm.t;
  key : PublicKey.t;
  body : string }

let sign_rsa ~hash ~priv body =
  let body = BlockBody.format body in
  let out = Filename.temp_file "" "" in
  let cmd = match hash with
  | HashAlgorithm.Sha1 ->
    Cmd.(v "openssl" % "dgst" % "-sha1" % "-sign" % priv % "-out" % out)
  | HashAlgorithm.Sha256 ->
    Cmd.(v "openssl" % "dgst" % "-sha256" % "-sign" % priv % "-out" % out) in
  ignore OS.Cmd.(run_in cmd (in_string body));
  In_channel.read_all out
  |> Base64.encode_exn

let sign ~hash ~public ~priv body =
  match public.PublicKey.algorithm with
  | RSA -> {
    hash_algorithm = hash;
    key = public;
    body = sign_rsa ~hash ~priv body
  }

let verify_rsa ~hash_algorithm ~key:PublicKey.{ key; _ } ~sign body =
  let unwrap result =
    result
    |> OS.Cmd.success
    |> Result.is_ok in
  let (key_file, oc) = Filename.open_temp_file "" "" in
  Printf.fprintf oc "%s" key;
  Out_channel.close oc;
  let (signature_file, oc) = Filename.open_temp_file "" "" in
  Printf.fprintf oc "%s" (Base64.decode_exn sign);
  Out_channel.close oc;
  let body = BlockBody.format body in
  let cmd = match hash_algorithm with
  | HashAlgorithm.Sha1 ->
    Cmd.(v
    "openssl" % "dgst" % "-sha1" % "-verify" % key_file % "-signature" % signature_file)
  | HashAlgorithm.Sha256 ->
    Cmd.(v
    "openssl" % "dgst" % "-sha256" % "-verify" % key_file % "-signature" % signature_file) in
  let result = OS.Cmd.(run_io cmd (in_string body) |> out_null) in
  unwrap result

let verify ~sign:{ hash_algorithm; key; body } block =
  match key.PublicKey.algorithm with
  | RSA -> verify_rsa ~hash_algorithm ~key ~sign:body block
