open Core

type t = Time.t

let of_string date_time =
  try Ok (Time.parse date_time ~fmt:"%Y%m%d%H%M%S" ~zone:Time.Zone.utc) with
  | Failure reason -> Error reason

let to_string date_time = Time.format date_time "%Y%m%d%H%M%S" ~zone:Time.Zone.utc

let pp ppf value = Time.pp ppf value

let to_time value = (value :> Time.t)
