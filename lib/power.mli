type t

val of_int : int -> t option
(** convert int to Power.t *)

val to_int : t -> int
(** convert Power.t to power *)
