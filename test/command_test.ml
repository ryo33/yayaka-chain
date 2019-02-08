open Core
open YayakaChain
module Test = Alcotest

let test_format () =
  Test.(check string) "add" "\
  7\n\
  add\n\
  rsa\n\
  2\n\
  -----BEGIN PUBLIC KEY-----\n\
  MB4wDQYJKoZIhvcNAQEBBQADDQAwCgIDAOCHAgMBAAE=\n\
  -----END PUBLIC KEY-----\n"
  (Command.(format (AddPublicKey {
    algorithm = PublicKeyAlgorithm.RSA;
    power = Option.value_exn (Power.of_int 2);
    key = "\
    -----BEGIN PUBLIC KEY-----\n\
    MB4wDQYJKoZIhvcNAQEBBQADDQAwCgIDAOCHAgMBAAE=\n\
    -----END PUBLIC KEY-----\n" })));

  Test.(check string) "remove" "\
  2\n\
  remove\n\
  +gf0YWKHMzO0/mCFlB9AivKRlD0="
  (Command.(format (RemovePublicKey {
    fingerprint = "+gf0YWKHMzO0/mCFlB9AivKRlD0=" })));

  Test.(check string) "update" "\
  3\n\
  update\n\
  +gf0YWKHMzO0/mCFlB9AivKRlD0=\n\
  3"
  (Command.(format (UpdatePower {
    fingerprint = "+gf0YWKHMzO0/mCFlB9AivKRlD0=";
    power = Option.value_exn (Power.of_int 3) })));

  Test.(check string) "halt" "\
  1\n\
  halt"
  (Command.(format (Halt)));

  Test.(check string) "user" "\
  4\n\
  user\n\
  some-protocol\n\
  some-command\n\
  some-body"
  (Command.(format (UserCommand {
    protocol = "some-protocol";
    body = "\
    some-command\n\
    some-body" })))

let pp ppf command = Fmt.pf ppf "%s" (Command.format command)

let command = Test.testable pp ( = )

let test_parse_unknown () =
  Test.(check (result command string)) "unknown"
  (Error "unknown command")
  (Command.parse "Add" [
  "rsa";
  "2";
  "-----BEGIN PUBLIC KEY-----";
  "MB4wDQYJKoZIhvcNAQEBBQADDQAwCgIDAOCHAgMBAAE=";
  "-----END PUBLIC KEY-----\n"])

let test_parse_add () =
  Test.(check (result command string)) "add"
  (Ok (AddPublicKey {
    algorithm = PublicKeyAlgorithm.RSA;
    power = Option.value_exn (Power.of_int 2);
    key = "\
    -----BEGIN PUBLIC KEY-----\n\
    MB4wDQYJKoZIhvcNAQEBBQADDQAwCgIDAOCHAgMBAAE=\n\
    -----END PUBLIC KEY-----\n" }))
  (Command.parse "add" [
  "rsa";
  "2";
  "-----BEGIN PUBLIC KEY-----";
  "MB4wDQYJKoZIhvcNAQEBBQADDQAwCgIDAOCHAgMBAAE=";
  "-----END PUBLIC KEY-----\n"]);

  Test.(check (result command string)) "failed to parse algorithm"
  (Error "failed to parse algorithm")
  (Command.parse "add" [
  "RSA";
  "2";
  "-----BEGIN PUBLIC KEY-----";
  "MB4wDQYJKoZIhvcNAQEBBQADDQAwCgIDAOCHAgMBAAE=";
  "-----END PUBLIC KEY-----\n"]);

  Test.(check (result command string)) "failed to parse power"
  (Error "failed to parse power")
  (Command.parse "add" [
  "rsa";
  "-1";
  "-----BEGIN PUBLIC KEY-----";
  "MB4wDQYJKoZIhvcNAQEBBQADDQAwCgIDAOCHAgMBAAE=";
  "-----END PUBLIC KEY-----\n"]);

  Test.(check (result command string)) "key is blank"
  (Error "key is blank")
  (Command.parse "add" ["rsa"; "1"; ""]);

  Test.(check (result command string)) "failed to parse algorithm\nfailed to parse power"
  (Error "failed to parse algorithm\nkey is blank")
  (Command.parse "add" ["Rsa"; "3"; ""]);

  Test.(check (result command string)) "failed to parse algorithm\nfailed to parse power"
  (Error "failed to parse algorithm\nfailed to parse power\nkey is blank")
  (Command.parse "add" ["Rsa"; "1."; ""]);

  Test.(check (result command string)) "wrong format"
  (Error "wrong format")
  (Command.parse "add" ["rsa"; "3"])

let test_parse_remove () =
  Test.(check (result command string)) "remove"
  (Ok (RemovePublicKey {
    fingerprint = "+gf0YWKHMzO0/mCFlB9AivKRlD0=" }))
  (Command.parse "remove" ["+gf0YWKHMzO0/mCFlB9AivKRlD0="]);

  Test.(check (result command string)) "wrong format"
  (Error "wrong format")
  (Command.parse "remove" ["+gf0YWK"; "HMzO0/mCFlB9AivKRlD0="]);

  Test.(check (result command string)) "fingerprint is blank"
  (Error "fingerprint is blank")
  (Command.parse "remove" [""])

let test_parse_update () =
  Test.(check (result command string)) "update"
  (Ok (UpdatePower {
    fingerprint = "+gf0YWKHMzO0/mCFlB9AivKRlD0=";
    power = Option.value_exn (Power.of_int 3)
  }))
  (Command.parse "update" [
    "+gf0YWKHMzO0/mCFlB9AivKRlD0=";
    "3"]);

  Test.(check (result command string)) "fingerprint is blank"
  (Error "fingerprint is blank")
  (Command.parse "update" [
    "";
    "3"]);

  Test.(check (result command string)) "failed to parse power"
  (Error "failed to parse power")
  (Command.parse "update" [
    "+gf0YWKHMzO0/mCFlB9AivKRlD0=";
    "3e"]);

  Test.(check (result command string)) "fingerprint is blank\nfailed to parse power"
  (Error "fingerprint is blank\nfailed to parse power")
  (Command.parse "update" [
    "";
    "3e"]);

  Test.(check (result command string)) "wrong format"
  (Error "wrong format")
  (Command.parse "update" ["+gf0YWKHMzO0/mCFlB9AivKRlD0="])

let test_parse_halt () =
  Test.(check (result command string)) "halt"
  (Ok Halt)
  (Command.parse "halt" []);

  Test.(check (result command string)) "wrong format"
  (Error "wrong format")
  (Command.parse "halt" ["a"])

let test_parse_user () =
  Test.(check (result command string)) "user"
  (Ok (UserCommand {
    protocol = "some-protocol";
    body = "\
    some-command\n\
    some-body" }))
  (Command.parse "user" ["some-protocol"; "some-command"; "some-body"]);

  Test.(check (result command string)) "only protocol name"
  (Ok (UserCommand {
    protocol = "some-protocol";
    body = "" }))
  (Command.parse "user" ["some-protocol"]);

  Test.(check (result command string)) "protocol is blank"
  (Error "protocol is blank")
  (Command.parse "user" [""; "some-command"; "some-body"]);

  Test.(check (result command string)) "wrong format"
  (Error "wrong format")
  (Command.parse "user" [])

let command_tests = [
  "format", `Quick, test_format;
  "parse unknown", `Quick, test_parse_unknown;
  "parse add", `Quick, test_parse_add;
  "parse remove", `Quick, test_parse_remove;
  "parse update", `Quick, test_parse_update;
  "parse halt", `Quick, test_parse_halt;
  "parse user", `Quick, test_parse_user;
]

let () =
  Test.run "Command" [
    "Command", command_tests;
  ]
