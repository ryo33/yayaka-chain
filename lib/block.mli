type t = { body : BlockBody.t; signatures : Signature.t list }

val format : t -> string
