open Rubik.Cube
open Rubik.Move
open Rubik.Solve

(* TODO: have ~50 tests that solve the full cube,
   and assert that state is correct after every step.
   Use a scramble instead of manually setting up cube state. *)
(* TODO: add more tests for edge cases within steps.
   Set up the cube state manually. *)

let assert_cross_top_face_is_solved cube =
  let fail_message =
    Printf.sprintf "Cross top face is solved: %s" (cube_to_string cube)
  in
  Alcotest.(check bool) fail_message true (cross_top_face_is_solved cube)

let assert_first_two_layers_are_solved cube =
  let fail_message =
    Printf.sprintf "First two layers are solved: %s" (cube_to_string cube)
  in
  let first_two_layers_are_solved =
    cross_bottom_face_is_solved cube
    && corners_bottom_layer_are_solved cube
    && edges_second_layer_are_solved cube
  in
  Alcotest.(check bool) fail_message true first_two_layers_are_solved

let solve_cross_already_solved () =
  let cube =
    {
      top_face =
        {
          fst = { fst = BLUE; snd = WHITE; trd = YELLOW };
          snd = { fst = WHITE; snd = WHITE; trd = WHITE };
          trd = { fst = WHITE; snd = WHITE; trd = RED };
        };
      top_layer =
        {
          front = { fst = BLUE; snd = GREEN; trd = GREEN };
          right = { fst = YELLOW; snd = RED; trd = BLUE };
          back = { fst = RED; snd = BLUE; trd = YELLOW };
          left = { fst = ORANGE; snd = ORANGE; trd = RED };
        };
      middle_layer =
        {
          front = { fst = YELLOW; snd = GREEN; trd = BLUE };
          right = { fst = ORANGE; snd = RED; trd = RED };
          back = { fst = BLUE; snd = BLUE; trd = RED };
          left = { fst = YELLOW; snd = ORANGE; trd = BLUE };
        };
      bottom_layer =
        {
          front = { fst = YELLOW; snd = RED; trd = GREEN };
          right = { fst = ORANGE; snd = ORANGE; trd = ORANGE };
          back = { fst = BLUE; snd = YELLOW; trd = WHITE };
          left = { fst = RED; snd = ORANGE; trd = GREEN };
        };
      bottom_face =
        {
          fst = { fst = ORANGE; snd = GREEN; trd = WHITE };
          snd = { fst = GREEN; snd = YELLOW; trd = YELLOW };
          trd = { fst = GREEN; snd = GREEN; trd = WHITE };
        };
    }
  in
  match solve_cross cube with
  | Error e -> failwith e
  | Ok moves ->
      let solved_cube = List.fold_left make_move cube moves in
      assert_cross_top_face_is_solved solved_cube

let solve_cross_edges_inserted_wrong_position () =
  let cube =
    {
      top_face =
        {
          fst = { fst = RED; snd = WHITE; trd = RED };
          snd = { fst = WHITE; snd = WHITE; trd = WHITE };
          trd = { fst = GREEN; snd = WHITE; trd = GREEN };
        };
      top_layer =
        {
          front = { fst = ORANGE; snd = BLUE; trd = YELLOW };
          right = { fst = RED; snd = ORANGE; trd = WHITE };
          back = { fst = GREEN; snd = RED; trd = YELLOW };
          left = { fst = BLUE; snd = GREEN; trd = WHITE };
        };
      middle_layer =
        {
          front = { fst = YELLOW; snd = GREEN; trd = ORANGE };
          right = { fst = BLUE; snd = RED; trd = YELLOW };
          back = { fst = ORANGE; snd = BLUE; trd = YELLOW };
          left = { fst = BLUE; snd = ORANGE; trd = RED };
        };
      bottom_layer =
        {
          front = { fst = YELLOW; snd = YELLOW; trd = BLUE };
          right = { fst = RED; snd = RED; trd = WHITE };
          back = { fst = ORANGE; snd = RED; trd = YELLOW };
          left = { fst = ORANGE; snd = GREEN; trd = ORANGE };
        };
      bottom_face =
        {
          fst = { fst = BLUE; snd = GREEN; trd = WHITE };
          snd = { fst = ORANGE; snd = YELLOW; trd = BLUE };
          trd = { fst = GREEN; snd = GREEN; trd = BLUE };
        };
    }
  in
  match solve_cross cube with
  | Error e -> failwith e
  | Ok moves ->
      let solved_cube = List.fold_left make_move cube moves in
      assert_cross_top_face_is_solved solved_cube

let solve_edges_second_layer_inserted_wrong_position () =
  let cube =
    {
      top_face =
        {
          fst = { fst = RED; snd = YELLOW; trd = GREEN };
          snd = { fst = YELLOW; snd = YELLOW; trd = YELLOW };
          trd = { fst = BLUE; snd = YELLOW; trd = YELLOW };
        };
      top_layer =
        {
          front = { fst = ORANGE; snd = BLUE; trd = GREEN };
          right = { fst = ORANGE; snd = ORANGE; trd = YELLOW };
          back = { fst = RED; snd = GREEN; trd = YELLOW };
          left = { fst = BLUE; snd = RED; trd = YELLOW };
        };
      middle_layer =
        {
          front = { fst = GREEN; snd = RED; trd = ORANGE };
          right = { fst = BLUE; snd = GREEN; trd = GREEN };
          back = { fst = ORANGE; snd = ORANGE; trd = BLUE };
          left = { fst = RED; snd = BLUE; trd = RED };
        };
      bottom_layer =
        {
          front = { fst = RED; snd = RED; trd = RED };
          right = { fst = GREEN; snd = GREEN; trd = GREEN };
          back = { fst = ORANGE; snd = ORANGE; trd = ORANGE };
          left = { fst = BLUE; snd = BLUE; trd = BLUE };
        };
      bottom_face =
        {
          fst = { fst = WHITE; snd = WHITE; trd = WHITE };
          snd = { fst = WHITE; snd = WHITE; trd = WHITE };
          trd = { fst = WHITE; snd = WHITE; trd = WHITE };
        };
    }
  in
  match solve_edges_second_layer cube with
  | Error e -> failwith e
  | Ok moves ->
      let solved_cube = List.fold_left make_move cube moves in
      assert_first_two_layers_are_solved solved_cube;
      ()

let solve_cube_test scramble =
  let cube = execute_scramble scramble in
  match solve cube with
  | Error e -> failwith e
  | Ok solution ->
      let solved_cube = List.fold_left make_move cube solution.moves in
      assert_first_two_layers_are_solved solved_cube;
      ()

let () =
  let open Alcotest in
  run "Solve"
    [
      ( "cross",
        [
          test_case "already solved" `Quick solve_cross_already_solved;
          test_case "edges inserted wrong position" `Quick
            solve_cross_edges_inserted_wrong_position;
        ] );
      ( "edges second layer",
        [
          test_case "edges inserted wrong position" `Quick
            solve_edges_second_layer_inserted_wrong_position;
        ] );
      ( "full solve",
        [
          test_case "scramble #1" `Quick (fun () ->
              solve_cube_test "D' R F D L F L' U L F U L' U B' L' U B R D L'");
          test_case "scramble #2" `Quick (fun () ->
              solve_cube_test "B F L U L' U L' U R' F L' F' L B' L D' B U L F'");
          test_case "scramble #3" `Quick (fun () ->
              solve_cube_test
                "L B' D F D' D' B' R' F R R R' F D' D' L U' R D U'");
          test_case "scramble #4" `Quick (fun () ->
              solve_cube_test
                "B' R' L B' F F' R' B B' D' D R D L' B' B U L' U D'");
          test_case "scramble #5" `Quick (fun () ->
              solve_cube_test
                "D' R' U' L B D' F L' B F U' U L R D' D' F' U' L L");
        ] );
    ]
