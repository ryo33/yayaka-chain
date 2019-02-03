type t = {
  version : string;
  previous_hash : Hash.t option;
  hash_algorithm : HashAlgorithm.t;
  expires_at : ExpirationDateTime.t;
  minimum_required_power_for_next_block : Power.t;
  commands : Command.t array;
  signatures : Signature.t array }

