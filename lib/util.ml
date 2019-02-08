open Core

let combine3results r1 r2 r3 ~ok ~err =
  Result.combine
  (Result.combine r1 r2 ~ok:(fun r1 r2 -> r1, r2) ~err)
  r3 ~ok:(fun (r1, r2) r3 -> ok r1 r2 r3) ~err
