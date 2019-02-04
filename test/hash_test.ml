open YayakaChain
module Test = Alcotest

let pp ppf = function
  | Hash.{ algorithm = Sha1; hash } -> Fmt.pf ppf "Sha1 %s" (Hex.(of_string hash |> show))
  | Hash.{ algorithm = Sha256; hash } -> Fmt.pf ppf "Sha256 %s" (Hex.(of_string hash |> show))

let hash = Test.testable pp ( = )

let h hex = Hex.to_string (`Hex hex)

let test_hash () =
  Test.(check hash) "a with sha1" {
    algorithm = Sha1;
    hash = (h "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8") }
    (Hash.hash Sha1 "a");
  Test.(check hash) "abc with sha1" {
    algorithm = Sha1;
    hash = (h "a9993e364706816aba3e25717850c26c9cd0d89d") }
    (Hash.hash Sha1 "abc");
  Test.(check hash) "a with sha256" {
    algorithm = Sha256;
    hash = (h "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb") }
    (Hash.hash Sha256 "a");
  Test.(check hash) "abc with sha256" {
    algorithm = Sha256;
    hash = (h "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad") }
    (Hash.hash Sha256 "abc")

let test_format () =
  Test.(check (pair string string)) "sha1"
  ("sha1", "qZk+NkcGgWq6PiVxeFDCbJzQ2J0=")
  (Hash.format {
    algorithm = Sha1;
    hash = (h "a9993e364706816aba3e25717850c26c9cd0d89d") });
  Test.(check (pair string string)) "sha256"
  ("sha256", "ungWv48Bz+pBQUDeXa4iI7ADYaOWF3qctBD/YfIAFa0=")
  (Hash.format {
    algorithm = Sha256;
    hash = (h "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad") })

let hash_tests = [
  "hash", `Quick, test_hash;
  "format", `Quick, test_format;
]

let () =
  Test.run "Hash" [
    "Hash", hash_tests;
  ]

