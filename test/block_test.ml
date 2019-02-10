open Core
open YayakaChain
module Test = Alcotest
open Support

let test_format () =
  Test.(check string) "format"
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
  3\n\
  2\n\
  qZk+NkcGgWq6PiVxeFDCbJzQ2J0=\n\
  sha1\n\
  +gf0YWKHMzO0/mCFlB9AivKRlD0=\n\
  sha256\n\
  1\n\
  FIcMDik/4+flC4gRsH76DReJhBqu6ZT2gO7kc4VEd5LryEoI/oxSH45PLW5glx0vCIoowirC87ZS\
  JVMTQn0S1FAhTwxZqW2ACgmmjFp0H7/rsK8j1UtjB1qHe/soxdcdqfM9/OswSEACqEeTtSlFbzVr\
  MruO3o6mfLIZZ3ay8ak=\n\
  1\n\
  QkCpjmf4UfLmhunz+/yYpo/zxrysJiFnT1aVKrT7ueFUDmltmFj+jt/MVBoB5Vb9zl68+TfCbwgw\
  I3jMwM6ZtJno+Vc6dks2lEkioc2dZ2F4jf0/aZ+KRK02evRATZD4gLq0jjmgS+XDCOafcbmJcjsr\
  hKwzjJkpZxKqM4MGiwo=\n"
  Block.(format {
    body = BlockBody.{
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
          -----END PUBLIC KEY-----\n" };
        Command.UpdatePower {
          fingerprint = "qZk+NkcGgWq6PiVxeFDCbJzQ2J0=";
          power = Option.value_exn (Power.of_int 3)
        };
      ];
      signature_declarations = [
        SignatureDeclaration.{
          fingerprint = "qZk+NkcGgWq6PiVxeFDCbJzQ2J0=";
          hash_algorithm = HashAlgorithm.Sha1;
        };
        SignatureDeclaration.{
          fingerprint = "+gf0YWKHMzO0/mCFlB9AivKRlD0=";
          hash_algorithm = HashAlgorithm.Sha256;
        };
      ]
    };
    signatures = [
      Signature.{
        hash_algorithm = HashAlgorithm.Sha1;
        key = {
          algorithm = PublicKeyAlgorithm.RSA;
          key = "\
          -----BEGIN PUBLIC KEY-----\n\
          MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC83PxbqZrsZEbQzFyULef0X3ti\n\
          tp2Hnv8f9uaevB1mtUSflc+cJOytKe7AFZEYkA3vWduSC4/1X8KbXs3A6BwD72ji\n\
          v6OqtM2hfROWEgx9xwC53bGtvf9EdMmSUncjGNfCdOvXqtFDZd+v7L5XTXO4D+Nj\n\
          znYGB5RL2EMLh4gcgQIDAQAB\n\
          -----END PUBLIC KEY-----\n";
          power = to_power 3
        };
        body = "\
        FIcMDik/4+flC4gRsH76DReJhBqu6ZT2gO7kc4VEd5LryEoI/oxSH45PLW5glx0vCIoowirC87ZS\
        JVMTQn0S1FAhTwxZqW2ACgmmjFp0H7/rsK8j1UtjB1qHe/soxdcdqfM9/OswSEACqEeTtSlFbzVr\
        MruO3o6mfLIZZ3ay8ak="
      };
      Signature.{
        hash_algorithm = HashAlgorithm.Sha256;
        key = {
          algorithm = PublicKeyAlgorithm.RSA;
          key = "\
          -----BEGIN PUBLIC KEY-----\n\
          MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC83PxbqZrsZEbQzFyULef0X3ti\n\
          tp2Hnv8f9uaevB1mtUSflc+cJOytKe7AFZEYkA3vWduSC4/1X8KbXs3A6BwD72ji\n\
          v6OqtM2hfROWEgx9xwC53bGtvf9EdMmSUncjGNfCdOvXqtFDZd+v7L5XTXO4D+Nj\n\
          znYGB5RL2EMLh4gcgQIDAQAB\n\
          -----END PUBLIC KEY-----\n";
          power = to_power 3
        };
        body = "\
        QkCpjmf4UfLmhunz+/yYpo/zxrysJiFnT1aVKrT7ueFUDmltmFj+jt/MVBoB5Vb9zl68+TfCbwgw\
        I3jMwM6ZtJno+Vc6dks2lEkioc2dZ2F4jf0/aZ+KRK02evRATZD4gLq0jjmgS+XDCOafcbmJcjsr\
        hKwzjJkpZxKqM4MGiwo="
      }
    ]
  });

  Test.(check string) "minimum"
  "\
  YAYAKA 0.1\n\
  1\n\
  sha1\n\
  hvfkN/qlp/zhXR3cuerq6jd2Z7g=\n\
  sha256\n\
  20190207120915\n\
  3\n\
  sha1\n\
  0\n\
  \n\
  0\n\
  \n\
  \n"
  Block.(format {
    body = BlockBody.{
      version = "0.1";
      layer = 1;
      previous_hash = Some Hash.{
        algorithm = HashAlgorithm.Sha1;
        hash = "hvfkN/qlp/zhXR3cuerq6jd2Z7g="};
      hash_algorithm = HashAlgorithm.Sha256;
      fingerprint_algorithm = HashAlgorithm.Sha1;
      expires_at = expiration_date_time_of_string "20190207120915";
      minimum_required_power = Option.value_exn (Power.of_int 3);
      commands = [];
      signature_declarations = []
    };
    signatures = []
  })

let block_tests = [
  "format", `Quick, test_format;
]

let () =
  Test.run "Block" [
    "Block", block_tests;
  ]
