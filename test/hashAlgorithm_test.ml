open YayakaChain
open HashAlgorithm
module Test = Alcotest

let pp ppf value =
  match value with
  | Sha1 -> Fmt.pf ppf "Sha1"
  | Sha256 -> Fmt.pf ppf "Sha256"

let hash_algorithm = Test.testable pp ( = )

let test_of_string () =
  Test.(check (option hash_algorithm)) "Sha-1" (Some Sha1) (of_string "Sha-1");
  Test.(check (option hash_algorithm)) "Sha-2" (Some Sha256) (of_string "Sha-2");
  Test.(check (option hash_algorithm)) "Sha256" None (of_string "Sha256")

let test_to_string () =
  Test.(check string) "Sha-1" "Sha-1" (to_string Sha1);
  Test.(check string) "Sha-2" "Sha-2" (to_string Sha256)

let hash_algorithm_tests = [
  "of_string", `Quick, test_of_string;
  "to_string", `Quick, test_to_string;
]

let () =
  Test.run "HashAlgorithm" [
    "HashAlgorithm", hash_algorithm_tests;
  ]

