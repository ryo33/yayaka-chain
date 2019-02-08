module YayakaHash = Hash
module YayakaCommand = Command
open Core

type t = {
  version : string;
  layer : int;
  previous_hash : YayakaHash.t option;
  hash_algorithm : HashAlgorithm.t;
  fingerprint_algorithm : HashAlgorithm.t;
  expires_at : ExpirationDateTime.t;
  minimum_required_power : Power.t;
  commands : YayakaCommand.t list;
  signature_declarations : SignatureDeclaration.t list }

let format {
  version; layer; previous_hash; hash_algorithm; fingerprint_algorithm;
  expires_at; minimum_required_power; commands; signature_declarations } =
  Format.sprintf "YAYAKA %s\n%d\n%s\n%s\n%s\n%d\n%s\n%d\n%s\n%d\n%s"
  version
  layer
  (Option.value_map previous_hash ~f:YayakaHash.format ~default:"\n")
  (HashAlgorithm.to_string hash_algorithm)
  (ExpirationDateTime.to_string expires_at)
  (Power.to_int minimum_required_power)
  (HashAlgorithm.to_string fingerprint_algorithm)
  (List.length commands)
  (commands
  |> List.map ~f:YayakaCommand.format
  |> String.concat ~sep:"\n")
  (List.length signature_declarations)
  (signature_declarations
  |> List.map ~f:SignatureDeclaration.format
  |> String.concat ~sep:"\n")
