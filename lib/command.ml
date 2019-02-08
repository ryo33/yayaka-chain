open Core

type t =
  | AddPublicKey of {
    algorithm : PublicKeyAlgorithm.t;
    power : Power.t;
    key : string }
  | RemovePublicKey of {
    fingerprint : string }
  | UpdatePower of {
    fingerprint : string;
    power : Power.t }
  | UserCommand of {
    protocol : string;
    body : string }
  | Halt

let format = function
  | AddPublicKey { algorithm; power; key } ->
    Format.sprintf "\
    %d\n\
    add\n\
    %s\n\
    %d\n\
    %s"
    (4 + String.count key ~f:(( = ) '\n'))
    (PublicKeyAlgorithm.to_string algorithm) (Power.to_int power) key
  | RemovePublicKey { fingerprint } ->
    Format.sprintf "\
    2\n\
    remove\n\
    %s"
    fingerprint
  | UpdatePower { fingerprint; power; } ->
    Format.sprintf "\
    3\n\
    update\n\
    %s\n\
    %d"
    fingerprint (Power.to_int power)
  | Halt -> "\
    1\n\
    halt"
  | UserCommand { protocol; body } ->
    Format.sprintf "\
    %d\n\
    user\n\
    %s\n\
    %s"
    (3 + String.count body ~f:(( = ) '\n')) protocol body

let combine3 r1 r2 r3 ~ok ~err =
  Result.combine
  (Result.combine r1 r2 ~ok:(fun r1 r2 -> r1, r2) ~err)
  r3 ~ok:(fun (r1, r2) r3 -> ok r1 r2 r3) ~err

let parse_power str =
  Power.parse str
  |> Result.of_option ~error:"failed to parse power"

let parse_fingerprint fingerprint =
  if String.is_empty fingerprint then Error "fingerprint is blank" else
    Ok fingerprint

let parse_add = function
  | algorithm :: power :: key when key <> [] ->
    let algorithm = PublicKeyAlgorithm.of_string(algorithm) in
    let power = parse_power power in
    let key = String.concat ~sep:"\n" key in
    combine3
    (Result.of_option algorithm ~error:"failed to parse algorithm")
    power
    (if String.is_empty key then Error "key is blank" else Ok key)
    ~ok:(fun algorithm power key -> AddPublicKey { algorithm; power; key })
    ~err:(fun a b -> a ^ "\n" ^ b)
  | _ -> Error "wrong format"

let parse_remove = function
  | [fingerprint] ->
    Result.map (parse_fingerprint fingerprint)
    ~f:(fun fingerprint -> RemovePublicKey { fingerprint })
  | _ -> Error "wrong format"

let parse_update = function
  | [fingerprint; power] ->
    let fingerprint = parse_fingerprint fingerprint in
    let power = parse_power power in
    Result.combine fingerprint power
    ~ok:(fun fingerprint power -> UpdatePower { fingerprint; power })
    ~err:(fun a b -> a ^ "\n" ^ b)
  | _ -> Error "wrong format"

let parse_halt = function
  | [] -> Ok Halt
  | _ -> Error "wrong format"

let parse_user = function
  | protocol :: body ->
    if String.is_empty protocol then Error "protocol is blank" else
      Ok (UserCommand { protocol; body = String.concat ~sep:"\n" body })
  | _ -> Error "wrong format"

let parse command body =
  match command with
  | "add" -> parse_add body
  | "remove" -> parse_remove body
  | "update" -> parse_update body
  | "halt" -> parse_halt body
  | "user" -> parse_user body
  | _ -> Error "unknown command"
