open Core
open YayakaChain

let to_power value = Option.value_exn (Power.of_int value)
