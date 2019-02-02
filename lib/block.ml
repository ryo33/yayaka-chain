type previous_block = { algorithm : string; hash : string }
type t = {
  version : string;
  previous_block : previous_block option;
  hash_algorithm : string;
  expires_at : ExpirationDateTime.t;
  minimum_required_power_for_next_block : Power.t;
  commands : Command.t array;
  signatures : Signature.t array }

