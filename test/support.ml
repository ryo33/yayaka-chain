open Core
open YayakaChain

let to_power value = Option.value_exn (Power.of_int value)

let expiration_date_time_of_string str =
  str
  |> ExpirationDateTime.of_string
  |> Result.map_error ~f:(fun a -> Failure a)
  |> Result.ok_exn
