open Core
open YayakaChain
module Test = Alcotest

let to_string time =
  Result.map time ~f: (fun time -> (time |> ExpirationDateTime.to_time |> Time.format) "%Y%m%d%H%M%S" ~zone:Time.Zone.utc)

let test_of_string () =
  Test.(check (result string string)) "20180207091315" (Ok "20180207091315")
  (to_string (ExpirationDateTime.of_string "20180207091315"));
  Test.(check (result string string)) "wrong format" (Error "unix_strptime: match failed")
  (to_string (ExpirationDateTime.of_string "2018020091315"))

let test_to_string () =
  Test.(check string) "20180207091315" "20180207091315"
  ("20180207091315"
  |> ExpirationDateTime.of_string
  |> Result.ok_or_failwith
  |> ExpirationDateTime.to_string)

let expiration_date_time_tests = [
  "of_string", `Quick, test_of_string;
  "to_string", `Quick, test_to_string;
]

let () =
  Test.run "ExpirationDateTime" [
    "ExpirationDateTime", expiration_date_time_tests;
  ]
