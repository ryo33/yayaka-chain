type t = {
  algorithm : PublicKeyAlgorithm.t;
  key : string;
  fingerprint_algorithm : HashAlgorithm.t;
  power : Power.t }

val fingerprint : t -> string
