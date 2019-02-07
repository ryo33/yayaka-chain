open Core

type t

val of_string : string -> (t, string) result

val to_string : t -> string

val pp : Format.formatter -> t -> unit

val to_time : t -> Time.t
