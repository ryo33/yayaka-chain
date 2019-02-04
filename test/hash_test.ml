open YayakaChain
module Test = Alcotest

let test_hash () =
  Test.(check string) "a with sha1"
    "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8"
    (Hash.hash HashAlgorithm.Sha1 "a");
  Test.(check string) "abc with sha1"
    "a9993e364706816aba3e25717850c26c9cd0d89d"
    (Hash.hash HashAlgorithm.Sha1 "abc");
  Test.(check string) "a with sha256"
    "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb"
    (Hash.hash HashAlgorithm.Sha256 "a");
  Test.(check string) "abc with sha256"
    "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
    (Hash.hash HashAlgorithm.Sha256 "abc")

let hash_tests = [
  "hash", `Quick, test_hash;
]

let () =
  Test.run "Hash" [
    "Hash", hash_tests;
  ]

