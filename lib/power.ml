type t = { value : int }

let of_int value =
  if value > 2147483647 then None else
  if value < 0 then None else
    Some { value = value }

let to_int { value } = value

let parse str =
  try of_int (int_of_string str) with
  | _ -> None
