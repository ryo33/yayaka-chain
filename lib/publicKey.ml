type t = {
  algorithm : PublicKeyAlgorithm.t;
  key : string;
  fingerprint_algorithm : HashAlgorithm.t;
  power : Power.t }

let fingerprint { fingerprint_algorithm; key; _ } =
  let Hash.{ hash; _ } = Hash.hash fingerprint_algorithm key in
  hash
