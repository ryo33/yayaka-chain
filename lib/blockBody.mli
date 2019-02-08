type t = {
  version : string;
  layer : int;
  previous_hash : Hash.t option;
  hash_algorithm : HashAlgorithm.t;
  fingerprint_algorithm : HashAlgorithm.t;
  expires_at : ExpirationDateTime.t;
  minimum_required_power : Power.t;
  commands : Command.t list; }

val format : t -> string
