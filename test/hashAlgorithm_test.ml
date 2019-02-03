open YayakaChain
open HashAlgorithm
module Test = Alcotest

let pp ppf value =
  match value with
  | SHA1 -> Fmt.pf ppf "SHA1"
  | SHA2 -> Fmt.pf ppf "SHA2"

let hash_algorithm = Test.testable pp ( = )

let test_from_string () =
  Test.(check (option hash_algorithm)) "SHA-1" (Some SHA1) (from_string "SHA-1");
  Test.(check (option hash_algorithm)) "SHA-2" (Some SHA2) (from_string "SHA-2");
  Test.(check (option hash_algorithm)) "SHA2" None (from_string "SHA2")

let test_to_string () =
  Test.(check string) "SHA-1" "SHA-1" (to_string SHA1);
  Test.(check string) "SHA-2" "SHA-2" (to_string SHA2)

let hash_algorithm_tests = [
  "from_string", `Quick, test_from_string;
  "to_string", `Quick, test_to_string;
]

let () =
  Test.run "HashAlgorithm" [
    "HashAlgorithm", hash_algorithm_tests;
  ]

