open Core

type t = {
  fingerprint : string;
  hash_algorithm : HashAlgorithm.t;
}

let format { fingerprint; hash_algorithm } =
  Format.sprintf "%s\n%s"
  fingerprint
  (HashAlgorithm.to_string hash_algorithm)

let parse ( fingerprint, hash_algorithm ) =
  let fingerprint = if String.is_empty fingerprint
  then Error "fingerprint is blank"
  else Ok fingerprint in
  let hash_algorithm =
    Result.of_option
    (HashAlgorithm.of_string hash_algorithm)
    ~error:"failed to parse hash_algorithm" in
  Result.combine fingerprint hash_algorithm
  ~ok:(fun fingerprint hash_algorithm -> {
    fingerprint; hash_algorithm })
  ~err:(fun a b -> a ^ "\n" ^ b)
  

