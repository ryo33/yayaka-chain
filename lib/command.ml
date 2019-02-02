type t =
  | AddPublicKey of {
    algorithm : string;
    key : string;
    power : Power.t }
  | RemovePublicKey of {
    fingerprint : string }
  | UserCommand of {
    protocol : string;
    body : string }
  | Halt
