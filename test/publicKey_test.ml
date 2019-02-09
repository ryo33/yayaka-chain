open YayakaChain
module Test = Alcotest
open Support

let test_fingerprint () =
  Test.(check string) "public key 1"
  "+gf0YWKHMzO0/mCFlB9AivKRlD0="
  (PublicKey.fingerprint ~alg:HashAlgorithm.Sha1 {
    algorithm = PublicKeyAlgorithm.RSA;
    power = to_power 1;
    key = "-----BEGIN PUBLIC KEY-----\n\
    MB4wDQYJKoZIhvcNAQEBBQADDQAwCgIDAOCHAgMBAAE=\n\
    -----END PUBLIC KEY-----\n" });

  Test.(check string) "public key 2"
  "s71Ok1G01SONnQB8hirmj/ZDgb8="
  (PublicKey.fingerprint ~alg:HashAlgorithm.Sha1 {
    algorithm = PublicKeyAlgorithm.RSA;
    power = to_power 1;
    key = "-----BEGIN PUBLIC KEY-----\n\
    MB4wDQYJKoZIhvcNAQEBBQADDQAwCgIDALy/AgMBAAE=\n\
    -----END PUBLIC KEY-----\n" })

let public_key_tests = [
  "fingerprint", `Quick, test_fingerprint
]

let () =
  Test.run "PublicKey" [
    "PublicKey", public_key_tests
  ]

