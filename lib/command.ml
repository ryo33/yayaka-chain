type t =
  | AddPublicKey of {
    algorithm : string;
    key : string;
    power : Power.t }
  | RemovePublicKey of {
    fingerprint : string }
  | UpdatePower of {
    fingerprint : string;
    power : Power.t }
  | UserCommand of {
    protocol : string;
    body : string }
  | Halt
