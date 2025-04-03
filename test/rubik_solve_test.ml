open Rubik.Cube
open Rubik.Solve

let cube =
  {
    top_face = {
      fst = { fst = WHITE; snd = GREEN; trd = RED; };
      snd = { fst = BLUE; snd = WHITE; trd = GREEN; };
      trd = { fst = YELLOW; snd = ORANGE; trd = YELLOW; };
    };
    top_layer = {
      front = { fst = RED; snd = BLUE; trd = RED; };
      right = { fst = GREEN; snd = ORANGE; trd = BLUE; };
      back = { fst = WHITE; snd = RED; trd = ORANGE; };
      left = { fst = GREEN; snd = YELLOW; trd = BLUE; };
    };
    middle_layer = {
      front = { fst = YELLOW; snd = GREEN; trd = ORANGE; };
      right = { fst = YELLOW; snd = RED; trd = YELLOW; };
      back = { fst = RED; snd = BLUE; trd = ORANGE; };
      left = { fst = WHITE; snd = ORANGE; trd = GREEN; };
    };
    bottom_layer = {
      front = { fst = WHITE; snd = BLUE; trd = YELLOW; };
      right = { fst = ORANGE; snd = RED; trd = BLUE; };
      back = { fst = WHITE; snd = BLUE; trd = BLUE; };
      left = { fst = ORANGE; snd = GREEN; trd = GREEN; };
    };
    bottom_face = {
      fst = { fst = RED; snd = RED; trd = GREEN; };
      snd = { fst = WHITE; snd = YELLOW; trd = WHITE; };
      trd = { fst = YELLOW; snd = WHITE; trd = ORANGE; };
    };
  }


let cube_cross_solved_testable =
  let cross_solved cube1 cube2 =
    cube1.top_face.fst.snd == cube2.top_face.fst.snd &&
    cube1.top_face.snd.fst == cube2.top_face.snd.fst &&
    cube1.top_face.snd.snd == cube2.top_face.snd.snd &&
    cube1.top_face.snd.trd == cube2.top_face.snd.trd &&
    cube1.top_face.trd.snd == cube2.top_face.trd.snd &&

    cube1.top_layer.front.snd == cube2.top_layer.front.snd &&
    cube1.top_layer.left.snd == cube2.top_layer.left.snd &&
    cube1.top_layer.right.snd == cube2.top_layer.right.snd &&
    cube1.top_layer.back.snd == cube2.top_layer.back.snd
  in
  Alcotest.testable Utils.cube_pretty_printer cross_solved

let expected = { cube with
  top_face = {
    fst = { cube.top_face.fst with snd = WHITE };
    snd = { fst = WHITE; snd = WHITE; trd = WHITE };
    trd = { cube.top_face.trd with snd = WHITE };
  };
  top_layer = {
    front = { cube.top_layer.front with snd = GREEN };
    left = { cube.top_layer.left with snd = ORANGE };
    right = { cube.top_layer.right with snd = RED };
    back = { cube.top_layer.back with snd = BLUE };
  };
}

(* TODO: make more tests, for example:
     1. cross is already solved
     2. only one edge is not solved
     
     tests for multiple different scrambles to really make sure it works
     3. solve all four edges #1
     4. solve all four edges #2
     5. solve all four edges #3
 *)

let solve_cross_test () =
  let actual = solve_cross cube in
  Alcotest.(check cube_cross_solved_testable)
    "cross solved"
    expected
    actual

let () =
  let open Alcotest in
  run "Solve"
    [
      ( "cross",
        [
          test_case "1" `Quick solve_cross_test;
        ] );
    ]
