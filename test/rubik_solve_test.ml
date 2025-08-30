open Rubik.Cube
open Rubik.Move
open Rubik.Solve

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
  | Ok solution_steps ->
      let all_moves =
        List.fold_left (fun moves step -> moves @ step.moves) [] solution_steps
      in
      let solved_cube = List.fold_left make_move cube all_moves in
      assert_first_two_layers_are_solved solved_cube;
      ()

let () =
  Logs.set_level (Some Logs.Debug);
  Logs.set_reporter (Logs_fmt.reporter ());
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
          test_case "scramble #6" `Quick (fun () ->
              solve_cube_test
                "L2 F' D2 R2 D2 F' D2 B' L2 B2 L2 D' L' D2 B' D' F' R' D' U2");
          test_case "scramble #7" `Quick (fun () ->
              solve_cube_test
                "F' R' D2 F2 D2 R2 B2 U2 R' D2 R' D2 B' D' F' L' D2 U' B' L");
          test_case "scramble #8" `Quick (fun () ->
              solve_cube_test
                "D2 F2 D2 L2 F' D2 F' L2 F2 D2 F' D' B' D2 R' F2 D' L' D2 U'");
          test_case "scramble #9" `Quick (fun () ->
              solve_cube_test
                "R2 D R2 U' L2 D2 R2 U' R2 D' F2 R' B' L2 D2 U' F' L' D2 U2");
          test_case "scramble #10" `Quick (fun () ->
              solve_cube_test
                "U2 L2 F2 L2 U' L2 D' B2 D2 F2 U' R' F' L' D' F' L2 D' B' D2");
          test_case "scramble #11" `Quick (fun () ->
              solve_cube_test
                "F2 R2 U2 F2 D' L2 F2 D2 F2 D' L2 F' L' B2 R' D' L' D2 F' L2");
          test_case "scramble #12" `Quick (fun () ->
              solve_cube_test
                "R2 D2 F2 R2 D' B2 D' R2 D' L2 F2 L' F' D' R' D2 F L F2 D");
          test_case "scramble #13" `Quick (fun () ->
              solve_cube_test
                "D2 F2 D2 L' B2 L' F2 R' D2 R2 D2 F' D' L2 B' D2 U' L' B2");
          test_case "scramble #14" `Quick (fun () ->
              solve_cube_test
                "U2 B2 U2 F2 L2 D' F2 D' B2 D' L2 F' D' F2 U' R D' F' L' D'");
          test_case "scramble #15" `Quick (fun () ->
              solve_cube_test
                "R2 D' F2 D' F2 D2 F2 U' L2 U' F2 R' F' D L' D2 F2 L2 F' D");
          test_case "scramble #16" `Quick (fun () ->
              solve_cube_test
                "F2 D2 R2 U2 B2 L' B2 L' F2 R' F2 D' L2 F' D' R' U' B' L' D2");
          test_case "scramble #17" `Quick (fun () ->
              solve_cube_test
                "B2 L2 D2 F2 D' F2 D' L2 D' R2 U2 R' B L' D' R2 F' D' R' U'");
          test_case "scramble #18" `Quick (fun () ->
              solve_cube_test
                "F2 R2 D' F2 D2 B2 D' L2 D' B2 U' F' R D' F' U2 B L' F2 D2");
          test_case "scramble #19" `Quick (fun () ->
              solve_cube_test
                "U2 F' R2 F' L2 F' R2 B' D2 L2 F2 R' D' L2 D2 B' D' L' F2");
          test_case "scramble #20" `Quick (fun () ->
              solve_cube_test
                "D2 F2 D2 F2 R2 D' L2 D' R2 F2 U' R' D' F' D2 L' F2 L2 D' U");
          test_case "scramble #21" `Quick (fun () ->
              solve_cube_test
                "R2 D2 L2 F2 D' L2 D' F2 D' L2 U' B' L' D' F' L2 B' R' D2 U'");
          test_case "scramble #22" `Quick (fun () ->
              solve_cube_test
                "B2 D2 R2 D' F2 D' L2 D2 L2 U' R2 B' L' F' U2 B' D' R' F2 U");
          test_case "scramble #23" `Quick (fun () ->
              solve_cube_test
                "F2 L2 D' L2 D' F2 U2 F2 D' F2 U' L' D2 F' D' L' D' B' L2 U'");
          test_case "scramble #24" `Quick (fun () ->
              solve_cube_test
                "R2 D2 F2 D' L2 D' L2 F2 D' F2 U2 B' R' F' D' L' D2 B' D U2");
          test_case "scramble #25" `Quick (fun () ->
              solve_cube_test
                "D2 R2 D2 F2 D' F2 D' R2 U' L2 U' F' L' D' F2 U' B' L' F' D");
          test_case "scramble #26" `Quick (fun () ->
              solve_cube_test
                "D2 B2 D2 F2 L2 D' L2 D F2 D' R2 U' B' R D' F L' D2 F' U");
          test_case "scramble #27" `Quick (fun () ->
              solve_cube_test
                "F2 D' F2 D' L2 U' F2 D' L2 F2 U2 R' F' D' L' F2 L2 D2 B' U2");
          test_case "scramble #28" `Quick (fun () ->
              solve_cube_test
                "U2 L2 F2 D' B2 D' F2 D' L2 D' R2 U' F' D2 L' D' F' R' B' D2");
          test_case "scramble #29" `Quick (fun () ->
              solve_cube_test
                "R2 D2 R2 D' L2 U' L2 D' R2 U' F2 R' F' D' L B' D2 F' L' U'");
          test_case "scramble #30" `Quick (fun () ->
              solve_cube_test
                "D2 B2 D2 L2 F2 D' F2 D' L2 D' R2 U' F' L' D' R' F' D2 L' U2");
          test_case "scramble #31" `Quick (fun () ->
              solve_cube_test
                "F2 D2 F2 D' L2 D' L2 D' F2 U' R2 B' L' D' F' L' D' B' D2 U");
          test_case "scramble #32" `Quick (fun () ->
              solve_cube_test
                "R2 D2 F2 D' F2 D' R2 D' L2 U' L2 F' L' D' F' U' B' L' D2 U2");
          test_case "scramble #33" `Quick (fun () ->
              solve_cube_test
                "U2 F2 D' L2 D' F2 D' L2 D' F2 U' R' F' D' L' D2 F' L' D' U'");
          test_case "scramble #34" `Quick (fun () ->
              solve_cube_test
                "D2 F2 D2 F2 D' L2 D' L2 U' R2 U' B' L' D' F' L' D2 B' D U'");
          test_case "scramble #35" `Quick (fun () ->
              solve_cube_test
                "R2 D2 F2 D' F2 D' L2 D' F2 U' R2 B' L' D' F' L' D2 B' D U'");
          test_case "scramble #36" `Quick (fun () ->
              solve_cube_test
                "F2 D2 F2 D' L2 D' L2 D' F2 U' R2 B' L' D' F' L' D' B' D2 U");
          test_case "scramble #37" `Quick (fun () ->
              solve_cube_test
                "U2 F2 D' L2 D' F2 D' L2 D' F2 U' R' F' D' L' D2 F' L' D' U'");
          test_case "scramble #38" `Quick (fun () ->
              solve_cube_test
                "D2 F2 D2 F2 D' L2 D' L2 U' R2 U' B' L' D' F' L' D2 B' D U'");
          test_case "scramble #39" `Quick (fun () ->
              solve_cube_test
                "R2 D2 F2 D' F2 D' L2 D' F2 U' R2 B' L' D' F' L' D2 B' D U'");
          test_case "scramble #40" `Quick (fun () ->
              solve_cube_test
                "F2 D2 F2 D' L2 D' L2 D' F2 U' R2 B' L' D' F' L' D' B' D2 U");
          test_case "scramble #41" `Quick (fun () ->
              solve_cube_test
                "U2 F2 D' L2 D' F2 D' L2 D' F2 U' R' F' D' L' D2 F' L' D' U'");
          test_case "scramble #42" `Quick (fun () ->
              solve_cube_test
                "D2 F2 D2 F2 D' L2 D' L2 U' R2 U' B' L' D' F' L' D2 B' D U'");
          test_case "scramble #43" `Quick (fun () ->
              solve_cube_test
                "R2 D2 F2 D' F2 D' L2 D' F2 U' R2 B' L' D' F' L' D2 B' D U'");
          test_case "scramble #44" `Quick (fun () ->
              solve_cube_test
                "F2 D2 F2 D' L2 D' L2 D' F2 U' R2 B' L' D' F' L' D' B' D2 U");
          test_case "scramble #45" `Quick (fun () ->
              solve_cube_test
                "U2 F2 D' L2 D' F2 D' L2 D' F2 U' R' F' D' L' D2 F' L' D' U'");
          test_case "scramble #46" `Quick (fun () ->
              solve_cube_test
                "D2 F2 D2 F2 D' L2 D' L2 U' R2 U' B' L' D' F' L' D2 B' D U'");
          test_case "scramble #47" `Quick (fun () ->
              solve_cube_test
                "R2 D2 F2 D' F2 D' L2 D' F2 U' R2 B' L' D' F' L' D2 B' D U'");
          test_case "scramble #48" `Quick (fun () ->
              solve_cube_test
                "F2 D2 F2 D' L2 D' L2 D' F2 U' R2 B' L' D' F' L' D' B' D2 U");
          test_case "scramble #49" `Quick (fun () ->
              solve_cube_test
                "U2 F2 D' L2 D' F2 D' L2 D' F2 U' R' F' D' L' D2 F' L' D' U'");
          test_case "scramble #50" `Quick (fun () ->
              solve_cube_test
                "D2 F2 D2 F2 D' L2 D' L2 U' R2 U' B' L' D' F' L' D2 B' D U'");
          test_case "scramble #51" `Quick (fun () ->
              solve_cube_test
                "R2 D2 F2 D' F2 D' L2 D' F2 U' R2 B' L' D' F' L' D2 B' D U'");
          test_case "scramble #52" `Quick (fun () ->
              solve_cube_test
                "F2 D2 F2 D' L2 D' L2 D' F2 U' R2 B' L' D' F' L' D' B' D2 U");
          test_case "scramble #53" `Quick (fun () ->
              solve_cube_test
                "U2 F2 D' L2 D' F2 D' L2 D' F2 U' R' F' D' L' D2 F' L' D' U'");
          test_case "scramble #54" `Quick (fun () ->
              solve_cube_test
                "D2 F2 D2 F2 D' L2 D' L2 U' R2 U' B' L' D' F' L' D2 B' D U'");
          test_case "scramble #55" `Quick (fun () ->
              solve_cube_test
                "R2 D2 F2 D' F2 D' L2 D' F2 U' R2 B' L' D' F' L' D2 B' D U'");
        ] );
    ]
