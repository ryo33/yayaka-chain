open YayakaChain
module Test = Alcotest

let test_format () =
  Test.(check string) "sha1 rsa" "\
  qZk+NkcGgWq6PiVxeFDCbJzQ2J0=\n\
  sha1"
  (SignatureDeclaration.format SignatureDeclaration.{
    fingerprint = "qZk+NkcGgWq6PiVxeFDCbJzQ2J0=";
    hash_algorithm = HashAlgorithm.Sha1;
  });

  Test.(check string) "sha2 rsa" "\
  QZk+NkcGgWq6PiVxeFDCbJzQ2J0=\n\
  sha256"
  (SignatureDeclaration.format SignatureDeclaration.{
    fingerprint = "QZk+NkcGgWq6PiVxeFDCbJzQ2J0=";
    hash_algorithm = HashAlgorithm.Sha256;
  })

let pp ppf t = Fmt.pf ppf "%s" (SignatureDeclaration.format t)

let signature_declaration = Test.testable pp ( = )

let test_parse () =
  Test.(check (result signature_declaration string)) "sha1 rsa"
  (Ok SignatureDeclaration.{
    fingerprint = "qZk+NkcGgWq6PiVxeFDCbJzQ2J0=";
    hash_algorithm = HashAlgorithm.Sha1;
  })
  (SignatureDeclaration.parse
  ("qZk+NkcGgWq6PiVxeFDCbJzQ2J0=",
  "sha1"));

  Test.(check (result signature_declaration string)) "sha256 rsa"
  (Ok SignatureDeclaration.{
    fingerprint = "QZk+NkcGgWq6PiVxeFDCbJzQ2J0=";
    hash_algorithm = HashAlgorithm.Sha256;
  })
  (SignatureDeclaration.parse
  ("QZk+NkcGgWq6PiVxeFDCbJzQ2J0=",
  "sha256"));

  Test.(check (result signature_declaration string)) "failed to parse"
  (Error "fingerprint is blank\nfailed to parse hash_algorithm")
  (SignatureDeclaration.parse
  ("",
  "Sha256"))

let signature_declaration_tests = [
  "format", `Quick, test_format;
  "parse", `Quick, test_parse;
]

let () =
  Test.run "SignatureDeclarations" [
    "SignatureDeclarations", signature_declaration_tests;
  ]
