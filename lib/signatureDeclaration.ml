open Core
open Util

type t = {
  fingerprint : string;
  hash_algorithm : HashAlgorithm.t;
  signature_algorithm : PublicKeyAlgorithm.t;
}

let format { fingerprint; hash_algorithm; signature_algorithm } =
  Format.sprintf "%s\n%s\n%s"
  fingerprint
  (HashAlgorithm.to_string hash_algorithm)
  (PublicKeyAlgorithm.to_string signature_algorithm)

let parse ( fingerprint, hash_algorithm, signature_algorithm ) =
  let fingerprint = if String.is_empty fingerprint
  then Error "fingerprint is blank"
  else Ok fingerprint in
  let hash_algorithm =
    Result.of_option
    (HashAlgorithm.of_string hash_algorithm)
    ~error:"failed to parse hash_algorithm" in
  let signature_algorithm =
    Result.of_option
    (PublicKeyAlgorithm.of_string signature_algorithm)
    ~error:"failed to parse signature_algorithm" in
  combine3results fingerprint hash_algorithm signature_algorithm
  ~ok:(fun fingerprint hash_algorithm signature_algorithm -> {
    fingerprint; hash_algorithm; signature_algorithm })
  ~err:(fun a b -> a ^ "\n" ^ b)
  

