type t =
  | AddPublicKey of {
    algorithm : PublicKeyAlgorithm.t;
    power : Power.t;
    key : string }
  | RemovePublicKey of {
    fingerprint : string }
  | UpdatePower of {
    fingerprint : string;
    power : Power.t }
  | UserCommand of {
    protocol : string;
    body : string }
  | Halt

val format : t -> string

val parse : string -> string list -> (t, string) result
