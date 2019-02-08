open Core
open YayakaChain
module Test = Alcotest

let a = Power.of_int 1

let expiration_date_time_of_string str =
  str
  |> ExpirationDateTime.of_string
  |> Result.map_error ~f:(fun a -> Failure a)
  |> Result.ok_exn

let test_format () =
  Test.(check string) "with commands"
  "\
  YAYAKA 0.1\n\
  1\n\
  sha1\n\
  hvfkN/qlp/zhXR3cuerq6jd2Z7g=\n\
  sha256\n\
  20190207120915\n\
  3\n\
  sha1\n\
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
  (BlockBody.format BlockBody.{
    version = "0.1";
    layer = 1;
    previous_hash = Some Hash.{
      algorithm = HashAlgorithm.Sha1;
      hash = "hvfkN/qlp/zhXR3cuerq6jd2Z7g="};
    hash_algorithm = HashAlgorithm.Sha256;
    fingerprint_algorithm = HashAlgorithm.Sha1;
    expires_at = expiration_date_time_of_string "20190207120915";
    minimum_required_power = Option.value_exn (Power.of_int 3);
    commands = [
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
    ]
  })

let block_body_tests = [
  "format", `Quick, test_format;
]

let () =
  Test.run "BlockBody" [
    "BlockBody", block_body_tests;
  ]
