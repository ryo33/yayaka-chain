type t

val of_int : int -> t option
(** converts int to Power.t.*)

val to_int : t -> int
(** converts Power.t to power. *)
