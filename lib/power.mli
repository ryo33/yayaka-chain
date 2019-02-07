type t

val of_int : int -> t option
(** converts int to Power.t.*)

val to_int : t -> int
(** converts Power.t to power. *)

val parse : string -> t option
(** parse the given string *)
