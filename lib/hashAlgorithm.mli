type t = Sha1 | Sha256

val of_string : string -> t option

val to_string : t -> string
