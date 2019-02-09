type t = {
  algorithm : PublicKeyAlgorithm.t;
  key : string;
  power : Power.t }

val fingerprint : alg:HashAlgorithm.t -> t -> string
