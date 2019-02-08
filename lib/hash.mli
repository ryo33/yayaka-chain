type t = { algorithm : HashAlgorithm.t; hash : string }

val hash : HashAlgorithm.t -> string -> t
(** computes a hash for the given string. *)

val format : t -> string
(** formats the given hash for block. *)
