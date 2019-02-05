open YayakaChain

let to_power value =
  match (Power.of_int value) with
  | Some power -> power
  | _ -> raise (Failure "")
