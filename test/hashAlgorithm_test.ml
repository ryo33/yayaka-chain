open YayakaChain
open HashAlgorithm
module Test = Alcotest

let pp ppf value = Fmt.pf ppf "%s" (to_string value)

let hash_algorithm = Test.testable pp ( = )

let test_of_string () =
  Test.(check (option hash_algorithm)) "sha1" (Some Sha1) (of_string "sha1");
  Test.(check (option hash_algorithm)) "sha256" (Some Sha256) (of_string "sha256");
  Test.(check (option hash_algorithm)) "Sha256" None (of_string "Sha256")

let test_to_string () =
  Test.(check string) "sha1" "sha1" (to_string Sha1);
  Test.(check string) "sha256" "sha256" (to_string Sha256)

let hash_algorithm_tests = [
  "of_string", `Quick, test_of_string;
  "to_string", `Quick, test_to_string;
]

let () =
  Test.run "HashAlgorithm" [
    "HashAlgorithm", hash_algorithm_tests;
  ]

