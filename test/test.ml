let success () =
  Alcotest.(check int) "1 = 1" 1 (2 - 1)

let test_set = [
  "Sample test" , `Quick, success;
]

let () =
  Alcotest.run "test for nothing" [
    "test_set", test_set;
  ]
