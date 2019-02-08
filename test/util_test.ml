open YayakaChain
module Test = Alcotest
open Util

let test_combine3results () =
  let ok = fun a b c -> a ^ b ^ c in
  let err = ( ^ ) in
  Test.(check (result string string)) "ok ok ok"
  (Ok "abc")
  (combine3results (Ok "a") (Ok "b") (Ok "c") ~ok ~err);

  let ok = fun a b c -> a ^ b ^ c in
  let err = ( ^ ) in
  Test.(check (result string string)) "err ok ok"
  (Error "a")
  (combine3results (Error "a") (Ok "b") (Ok "c") ~ok ~err);

  let ok = fun a b c -> a ^ b ^ c in
  let err = ( ^ ) in
  Test.(check (result string string)) "ok err ok"
  (Error "b")
  (combine3results (Ok "a") (Error "b") (Ok "c") ~ok ~err);

  let ok = fun a b c -> a ^ b ^ c in
  let err = ( ^ ) in
  Test.(check (result string string)) "ok ok err"
  (Error "c")
  (combine3results (Ok "a") (Ok "b") (Error "c") ~ok ~err);

  let ok = fun a b c -> a ^ b ^ c in
  let err = ( ^ ) in
  Test.(check (result string string)) "err err ok"
  (Error "ab")
  (combine3results (Error "a") (Error "b") (Ok "c") ~ok ~err);

  let ok = fun a b c -> a ^ b ^ c in
  let err = ( ^ ) in
  Test.(check (result string string)) "ok err err"
  (Error "bc")
  (combine3results (Ok "a") (Error "b") (Error "c") ~ok ~err);

  let ok = fun a b c -> a ^ b ^ c in
  let err = ( ^ ) in
  Test.(check (result string string)) "err ok err"
  (Error "ac")
  (combine3results (Error "a") (Ok "b") (Error "c") ~ok ~err);

  let ok = fun a b c -> a ^ b ^ c in
  let err = ( ^ ) in
  Test.(check (result string string)) "err err err"
  (Error "abc")
  (combine3results (Error "a") (Error "b") (Error "c") ~ok ~err)

let util_tests = [
  "combine3results", `Quick, test_combine3results;
]

let () =
  Test.run "Util" [
    "Util", util_tests;
  ]

