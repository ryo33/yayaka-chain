open Core
open YayakaChain
module Test = Alcotest

let to_int_option = Option.map ~f:Power.to_int
let to_power value =
  match (Power.from_int value) with
  | Some power -> power
  | _ -> raise (Failure "")

let from_int () =
  Test.(check (option int)) "0" (Some 0) (to_int_option (Power.from_int 0));
  Test.(check (option int)) "1,000,000" (Some 1000000) (to_int_option (Power.from_int 1000000));
  Test.(check (option int)) "2 ^ 31 - 1" (Some 2147483647) (to_int_option (Power.from_int 2147483647));
  Test.(check (option int)) "2 ^ 31" None (to_int_option (Power.from_int 2147483648));
  Test.(check (option int)) "-1" None (to_int_option (Power.from_int ~- 1));
  Test.(check (option int)) "-1,000,000" None (to_int_option (Power.from_int ~- 1000000))

let to_int () =
  Test.(check int) "0" 0 (Power.to_int (to_power 0));
  Test.(check int) "1,000,000" 1000000 (Power.to_int (to_power 1000000));
  Test.(check int) "2 ^ 31 - 1" 2147483647 (Power.to_int (to_power 2147483647))

let power_tests = [
  "from_int", `Quick, from_int;
  "to_int", `Quick, to_int;
]

let () =
  Test.run "Power" [
    "Power", power_tests;
  ]
