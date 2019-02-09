type t = {
  algorithm : PublicKeyAlgorithm.t;
  key : string;
  power : Power.t }

let fingerprint ~alg { key; _ } =
  let Hash.{ hash; _ } = Hash.hash alg key in
  hash
