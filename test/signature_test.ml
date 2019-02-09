open Core
open YayakaChain
module Test = Alcotest
open Support

let pp ppf Signature.{ hash_algorithm; key = {algorithm; key; power}; body } =
  Fmt.pf ppf "%s\n%s\n%s"
  (HashAlgorithm.to_string hash_algorithm)
  (Format.sprintf "%s\n%s\n%d" (PublicKeyAlgorithm.to_string algorithm) key
  (Power.to_int power))
  body

let signature = Test.testable pp ( = )

let test_sign () =
  let (key_file, oc) = Filename.open_temp_file "" "" in
  Printf.fprintf oc "%s" "\
  -----BEGIN RSA PRIVATE KEY-----\n\
  MIICXQIBAAKBgQC83PxbqZrsZEbQzFyULef0X3titp2Hnv8f9uaevB1mtUSflc+c\n\
  JOytKe7AFZEYkA3vWduSC4/1X8KbXs3A6BwD72jiv6OqtM2hfROWEgx9xwC53bGt\n\
  vf9EdMmSUncjGNfCdOvXqtFDZd+v7L5XTXO4D+NjznYGB5RL2EMLh4gcgQIDAQAB\n\
  AoGAMauc4y6UBB/LUBavMnlwS6Dg/nEwtP5n8qwosw6eXOjHh4EK/PHpHRGuLO5/\n\
  HoqkX5KuYJaR4eKxd9NTIazp0NtbXvZx/GyX+j0KjqsS1tcMrLQaCQhKl7Pn8E+v\n\
  bxeRmQPuz1DP3fpy04TrKPUG1x9qrxwrL2Yw4b4+rGHecAECQQDmAthkbqaqfmQc\n\
  Jv7UVa5H8ff0CcQCSruPnfmPmxummWX1GrmV7bE7ugtiXwA8XSv+1itu99V/qSOS\n\
  UVjBC9XhAkEA0jPsRH+Ii/8r9MkCGK3PpYDjhw2bZUS5ZYCcJzUpva9Kxa+uN5jK\n\
  gsaOgMR9Bv3FTgoX5HqhoM6zXcL2b5XaoQJAP9OGTMhPw3vzN8SybiWgiSJiFfwn\n\
  wiMOzRmfSPRXxfFHU66o1SvyRIqp4hBOtnF8Zej0gISRYC2FS3L7WAZ6wQJBAIpO\n\
  UansQ/rhRZnFXFTCoDqkaJCm+lUSd+36RkRh7Xn6SXdzFW1NYgnT/VVqc11TQiwL\n\
  5haWPZyiBFCwBBf9gKECQQDOAwKN8nE+JXoi7j7lDAfwoVy6MrI6e9xT60qDrW8Z\n\
  nSogAG4ZFfhlpzvBonhBpghIsVE4JbgNlnKywgOztCd7\n\
  -----END RSA PRIVATE KEY-----\n";
  Out_channel.close oc;

  Test.check signature "sign sha1"
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
  }
  (Signature.sign
  ~hash:HashAlgorithm.Sha1
  ~public:{
    algorithm = PublicKeyAlgorithm.RSA;
    key = "\
    -----BEGIN PUBLIC KEY-----\n\
    MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC83PxbqZrsZEbQzFyULef0X3ti\n\
    tp2Hnv8f9uaevB1mtUSflc+cJOytKe7AFZEYkA3vWduSC4/1X8KbXs3A6BwD72ji\n\
    v6OqtM2hfROWEgx9xwC53bGtvf9EdMmSUncjGNfCdOvXqtFDZd+v7L5XTXO4D+Nj\n\
    znYGB5RL2EMLh4gcgQIDAQAB\n\
    -----END PUBLIC KEY-----\n";
    power = to_power 3
  }
  ~priv:key_file
  BlockBody.{
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
  });

  Test.check signature "sign sha256"
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
  (Signature.sign
  ~hash:HashAlgorithm.Sha256
  ~public:{
    algorithm = PublicKeyAlgorithm.RSA;
    key = "\
    -----BEGIN PUBLIC KEY-----\n\
    MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC83PxbqZrsZEbQzFyULef0X3ti\n\
    tp2Hnv8f9uaevB1mtUSflc+cJOytKe7AFZEYkA3vWduSC4/1X8KbXs3A6BwD72ji\n\
    v6OqtM2hfROWEgx9xwC53bGtvf9EdMmSUncjGNfCdOvXqtFDZd+v7L5XTXO4D+Nj\n\
    znYGB5RL2EMLh4gcgQIDAQAB\n\
    -----END PUBLIC KEY-----\n";
    power = to_power 3
  }
  ~priv:key_file
  BlockBody.{
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
  })

let test_verify () =
  Test.(check bool) "sha1 OK"
  true
  (Signature.verify
  ~sign:Signature.{
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
  }
  BlockBody.{
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
  });

  Test.(check bool) "sha1 Failure"
  false
  (Signature.verify
  ~sign:Signature.{
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
  }
  BlockBody.{
    version = "0.1";
    layer = 10;
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
  });

  Test.(check bool) "sha256 OK"
  true
  (Signature.verify
  ~sign:Signature.{
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
  BlockBody.{
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
  });

  Test.(check bool) "sha256 Failure"
  false
  (Signature.verify
  ~sign:Signature.{
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
  BlockBody.{
    version = "0.1";
    layer = 10;
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
  })

let signature_tests = [
  "sign", `Quick, test_sign;
  "verify", `Quick, test_verify;
]

let () =
  Test.run "Signature" [
    "Signature", signature_tests;
  ]
