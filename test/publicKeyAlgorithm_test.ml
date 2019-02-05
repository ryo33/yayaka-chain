open YayakaChain
open PublicKeyAlgorithm
module Test = Alcotest

let pp ppf value = Fmt.pf ppf "%s" (to_string value)

let public_key_algorithm = Test.testable pp ( = )

let test_of_string () =
  Test.(check (option public_key_algorithm)) "rsa" (Some RSA) (of_string "rsa");
  Test.(check (option public_key_algorithm)) "RSA" None (of_string "RSA");
  Test.(check (option public_key_algorithm)) "Rsa" None (of_string "rSa")

let test_to_string () =
  Test.(check string) "RSA" "rsa" (to_string RSA)

let public_key_algorithm_tests = [
  "of_string", `Quick, test_of_string;
  "to_string", `Quick, test_to_string;
]

let () =
  Test.run "PublicKeyAlgorithm" [
    "PublicKeyAlgorithm", public_key_algorithm_tests;
  ]

