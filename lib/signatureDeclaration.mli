type t = {
  fingerprint : string;
  hash_algorithm : HashAlgorithm.t;
  signature_algorithm : PublicKeyAlgorithm.t;
}

val format : t -> string

val parse : (string * string * string) -> (t, string) result
