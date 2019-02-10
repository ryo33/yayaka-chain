open YayakaChain
module Test = Alcotest
open Support

let test_format () =
  Test.(check string) "0"
  ""
  (Signatures.format []);

  Test.(check string) "2" "\
  1\n\
  QkCpjmf4UfLmhunz+/yYpo/zxrysJiFnT1aVKrT7ueFUDmltmFj+jt/MVBoB5Vb9zl68+TfCbwgw\
  I3jMwM6ZtJno+Vc6dks2lEkioc2dZ2F4jf0/aZ+KRK02evRATZD4gLq0jjmgS+XDCOafcbmJcjsr\
  hKwzjJkpZxKqM4MGiwo=\n\
  3\n\
  QkCpjmf4UfLmhunz+/yYpo/zxrysJiFnT1aVKrT7ueFUDmltmFj+jt/MVBoB5Vb9zl68+TfCbwgw\
  I3jMwM6ZtJno+Vc6dks2lEkioc2dZ2F4jf0/aZ+KRK02evRATZD4gLq0jjmgS+XDCOafcbmJcjsr\n\
  hKwzjJkpZxKqM4MGiwo=\n"
  (Signatures.format [
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
      I3jMwM6ZtJno+Vc6dks2lEkioc2dZ2F4jf0/aZ+KRK02evRATZD4gLq0jjmgS+XDCOafcbmJcjsr\n\
      hKwzjJkpZxKqM4MGiwo=\n"
    }
  ])

let signatures_tests = [
  "format", `Quick, test_format;
]

let () =
  Test.run "Signatures" [
    "Signatures", signatures_tests;
  ]
