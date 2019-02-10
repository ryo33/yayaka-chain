open YayakaChain
module Test = Alcotest

let test_format () =
  Test.(check string) "0"
  "0\n"
  (SignatureDeclarations.format []);

  Test.(check string) "2" "\
  2\n\
  qZk+NkcGgWq6PiVxeFDCbJzQ2J0=\n\
  sha1\n\
  +gf0YWKHMzO0/mCFlB9AivKRlD0=\n\
  sha256"
  (SignatureDeclarations.format [
    SignatureDeclaration.{
      fingerprint = "qZk+NkcGgWq6PiVxeFDCbJzQ2J0=";
      hash_algorithm = HashAlgorithm.Sha1;
    };
    SignatureDeclaration.{
      fingerprint = "+gf0YWKHMzO0/mCFlB9AivKRlD0=";
      hash_algorithm = HashAlgorithm.Sha256;
    };
  ])

let signatures_tests = [
  "format", `Quick, test_format;
]

let () =
  Test.run "SignatureDeclarations" [
    "SignatureDeclarations", signatures_tests;
  ]
