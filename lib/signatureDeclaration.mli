type t = {
  fingerprint : string;
  hash_algorithm : HashAlgorithm.t;
}

val format : t -> string

val parse : (string * string) -> (t, string) result
