type t = {
  hash_algorithm : HashAlgorithm.t;
  key : PublicKey.t;
  body : string }

val sign :
  hash:HashAlgorithm.t -> public:PublicKey.t -> priv:string -> BlockBody.t -> t

val verify :
  sign:t -> BlockBody.t -> bool

val format : t -> string
