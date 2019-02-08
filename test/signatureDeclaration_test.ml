open YayakaChain
module Test = Alcotest

let test_format () =
  Test.(check string) "sha1 rsa" "\
  qZk+NkcGgWq6PiVxeFDCbJzQ2J0=\n\
  sha1\n\
  rsa"
  (SignatureDeclaration.format SignatureDeclaration.{
    fingerprint = "qZk+NkcGgWq6PiVxeFDCbJzQ2J0=";
    hash_algorithm = HashAlgorithm.Sha1;
    signature_algorithm = PublicKeyAlgorithm.RSA
  });

  Test.(check string) "sha2 rsa" "\
  QZk+NkcGgWq6PiVxeFDCbJzQ2J0=\n\
  sha256\n\
  rsa"
  (SignatureDeclaration.format SignatureDeclaration.{
    fingerprint = "QZk+NkcGgWq6PiVxeFDCbJzQ2J0=";
    hash_algorithm = HashAlgorithm.Sha256;
    signature_algorithm = PublicKeyAlgorithm.RSA
  })

let pp ppf t = Fmt.pf ppf "%s" (SignatureDeclaration.format t)

let signature_declaration = Test.testable pp ( = )

let test_parse () =
  Test.(check (result signature_declaration string)) "sha1 rsa"
  (Ok SignatureDeclaration.{
    fingerprint = "qZk+NkcGgWq6PiVxeFDCbJzQ2J0=";
    hash_algorithm = HashAlgorithm.Sha1;
    signature_algorithm = PublicKeyAlgorithm.RSA
  })
  (SignatureDeclaration.parse
  ("qZk+NkcGgWq6PiVxeFDCbJzQ2J0=",
  "sha1",
  "rsa"));

  Test.(check (result signature_declaration string)) "sha256 rsa"
  (Ok SignatureDeclaration.{
    fingerprint = "QZk+NkcGgWq6PiVxeFDCbJzQ2J0=";
    hash_algorithm = HashAlgorithm.Sha256;
    signature_algorithm = PublicKeyAlgorithm.RSA
  })
  (SignatureDeclaration.parse
  ("QZk+NkcGgWq6PiVxeFDCbJzQ2J0=",
  "sha256",
  "rsa"));

  Test.(check (result signature_declaration string)) "failed to parse"
  (Error "fingerprint is blank\nfailed to parse signature_algorithm")
  (SignatureDeclaration.parse
  ("",
  "sha256",
  "RSA"))

let signature_declaration_tests = [
  "format", `Quick, test_format;
  "parse", `Quick, test_parse;
]

let () =
  Test.run "SignatureDeclarations" [
    "SignatureDeclarations", signature_declaration_tests;
  ]
