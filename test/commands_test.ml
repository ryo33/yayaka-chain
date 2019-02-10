open Core
open YayakaChain
module Test = Alcotest

let test_format () =
  Test.(check string) "0"
  "0\n"
  (Commands.format []);

  Test.(check string) "2" "\
  2\n\
  7\n\
  add\n\
  rsa\n\
  2\n\
  -----BEGIN PUBLIC KEY-----\n\
  MB4wDQYJKoZIhvcNAQEBBQADDQAwCgIDAOCHAgMBAAE=\n\
  -----END PUBLIC KEY-----\n\
  \n\
  3\n\
  update\n\
  qZk+NkcGgWq6PiVxeFDCbJzQ2J0=\n\
  3"
  (Commands.format [
    Command.AddPublicKey {
      algorithm = PublicKeyAlgorithm.RSA;
      power = Option.value_exn (Power.of_int 2);
      key = "\
      -----BEGIN PUBLIC KEY-----\n\
      MB4wDQYJKoZIhvcNAQEBBQADDQAwCgIDAOCHAgMBAAE=\n\
      -----END PUBLIC KEY-----\n"
    };
    Command.UpdatePower {
      fingerprint = "qZk+NkcGgWq6PiVxeFDCbJzQ2J0=";
      power = Option.value_exn (Power.of_int 3)
    };
  ])

let signatures_tests = [
  "format", `Quick, test_format;
]

let () =
  Test.run "Commands" [
    "Commands", signatures_tests;
  ]
