open Ppx_yojson_conv_lib.Yojson_conv.Primitives
open Cube
open Move

type solution = { moves : move list } [@@deriving yojson]

let solve_cross_next_moves cube =
  let cross_color = cube.top_face.snd.snd in
  if cube.bottom_face.fst.snd == cross_color then
    let is_matching_edge =
      cube.bottom_layer.front.snd == cube.middle_layer.front.snd
    in
    if is_matching_edge then
        [
          { move_type = FRONT; clockwise = true };
          { move_type = FRONT; clockwise = true };
        ]
    else [ { move_type = DOWN; clockwise = true } ]
  else if cube.middle_layer.front.fst == cross_color then
    let is_matching_edge =
      cube.middle_layer.left.trd == cube.middle_layer.left.snd
    in
    if is_matching_edge then [ { move_type = LEFT; clockwise = false } ]
    else
        [
          { move_type = LEFT; clockwise = true };
          { move_type = DOWN; clockwise = true };
          { move_type = LEFT; clockwise = false };
        ]
  else if cube.middle_layer.front.trd == cross_color then
    let is_matching_edge =
      cube.middle_layer.right.fst == cube.middle_layer.right.snd
    in
    if is_matching_edge then [ { move_type = RIGHT; clockwise = true } ]
    else
        [
          { move_type = RIGHT; clockwise = false };
          { move_type = DOWN; clockwise = true };
          { move_type = RIGHT; clockwise = true };
        ]
  else if
    cube.top_face.trd.snd == cross_color
    && cube.top_layer.front.snd != cube.middle_layer.front.snd
  then
      [
        { move_type = FRONT; clockwise = true };
        { move_type = FRONT; clockwise = true };
        { move_type = DOWN; clockwise = true };
      ]
  else if cube.top_layer.front.snd == cross_color then
    [ { move_type = FRONT; clockwise = true } ]
  else if cube.bottom_layer.front.snd == cross_color then
    [ { move_type = FRONT; clockwise = true } ]
  else [ { move_type = ROTATE_Y; clockwise = true } ]

let solve_corners_first_layer_next_moves cube =
  let cross_color = cube.top_face.snd.snd in
  if cube.bottom_layer.front.fst == cross_color then
    let in_right_position =
      cube.bottom_layer.left.trd == cube.middle_layer.left.snd
    in
    if in_right_position then
        [
          { move_type = DOWN; clockwise = true };
          { move_type = LEFT; clockwise = true };
          { move_type = DOWN; clockwise = false };
          { move_type = LEFT; clockwise = false };
        ]
    else [ { move_type = DOWN; clockwise = true } ]
  else if cube.bottom_layer.front.trd == cross_color then
    let in_right_position =
      cube.bottom_layer.right.fst == cube.middle_layer.right.snd
    in
    if in_right_position then
        [
          { move_type = DOWN; clockwise = false };
          { move_type = RIGHT; clockwise = false };
          { move_type = DOWN; clockwise = true };
          { move_type = RIGHT; clockwise = true };
        ]
    else [ { move_type = DOWN; clockwise = true } ]
  else if
    cube.top_layer.front.fst == cross_color
    || cube.top_face.trd.fst == cross_color
       && cube.top_layer.front.fst <> cube.top_layer.front.snd
  then
      [
        { move_type = LEFT; clockwise = true };
        { move_type = DOWN; clockwise = false };
        { move_type = LEFT; clockwise = false };
      ]
  else if
    cube.top_layer.front.trd == cross_color
    || cube.top_face.trd.trd == cross_color
       && cube.top_layer.front.trd <> cube.top_layer.front.snd
  then
      [
        { move_type = RIGHT; clockwise = false };
        { move_type = DOWN; clockwise = true };
        { move_type = RIGHT; clockwise = true };
      ]
  else if cube.bottom_face.fst.fst == cross_color then
    let in_right_position =
      cube.bottom_layer.left.trd == cube.middle_layer.front.snd
    in
    if in_right_position then
        [
          { move_type = DOWN; clockwise = true };
          { move_type = LEFT; clockwise = true };
          { move_type = DOWN; clockwise = true };
          { move_type = DOWN; clockwise = true };
          { move_type = LEFT; clockwise = false };
        ]
    else [ { move_type = DOWN; clockwise = true } ]
  else if cube.bottom_face.fst.trd == cross_color then
    let in_right_position =
      cube.bottom_layer.right.fst == cube.middle_layer.front.snd
    in
    if in_right_position then
        [
          { move_type = DOWN; clockwise = false };
          { move_type = RIGHT; clockwise = false };
          { move_type = DOWN; clockwise = true };
          { move_type = DOWN; clockwise = true };
          { move_type = RIGHT; clockwise = true };
        ]
    else [ { move_type = DOWN; clockwise = true } ]
  else [ { move_type = ROTATE_Y; clockwise = true } ]

let solve_edges_second_layer_next_moves cube =
  let rec solve_edges_second_layer_next_moves_helper cube moves n =
    if (cube.top_face.fst.snd == YELLOW || cube.top_layer.back.snd == YELLOW)
      && (cube.top_face.snd.fst == YELLOW || cube.top_layer.left.snd == YELLOW)
      && (cube.top_face.snd.trd == YELLOW || cube.top_layer.right.snd == YELLOW)
      && (cube.top_face.trd.snd == YELLOW || cube.top_layer.front.snd == YELLOW)
    then
      moves @ [
        { move_type = UP; clockwise = true; };
        { move_type = RIGHT; clockwise = true; };
        { move_type = UP; clockwise = true; };
        { move_type = RIGHT; clockwise = false; };
        { move_type = UP; clockwise = false; };
        { move_type = FRONT; clockwise = false; };
        { move_type = UP; clockwise = false; };
        { move_type = FRONT; clockwise = true; };
      ]
    else if n == 4 then
      moves @ [ { move_type = ROTATE_Y; clockwise = true } ]
    else if cube.top_layer.front.snd == cube.middle_layer.front.snd
      && cube.top_face.trd.snd == cube.middle_layer.right.snd
    then
      moves @ [
        { move_type = UP; clockwise = true; };
        { move_type = RIGHT; clockwise = true; };
        { move_type = UP; clockwise = true; };
        { move_type = RIGHT; clockwise = false; };
        { move_type = UP; clockwise = false; };
        { move_type = FRONT; clockwise = false; };
        { move_type = UP; clockwise = false; };
        { move_type = FRONT; clockwise = true; };
      ]
    else if cube.top_layer.front.snd == cube.middle_layer.front.snd
      && cube.top_face.trd.snd == cube.middle_layer.left.snd
    then
      moves @ [
        { move_type = UP; clockwise = false; };
        { move_type = LEFT; clockwise = false; };
        { move_type = UP; clockwise = false; };
        { move_type = LEFT; clockwise = true; };
        { move_type = UP; clockwise = true; };
        { move_type = FRONT; clockwise = true; };
        { move_type = UP; clockwise = true; };
        { move_type = FRONT; clockwise = false; };
      ]
    else
      let move = { move_type = UP; clockwise = true } in
      let new_cube = make_move cube move in
      solve_edges_second_layer_next_moves_helper new_cube (moves @ [ move ]) (n + 1)
  in solve_edges_second_layer_next_moves_helper cube [] 0

let solve_step error_condition error_msg step_solved get_next_moves cube =
  let rec solve_step_helper cube moves =
    if error_condition moves then
      Error error_msg
    else if step_solved cube then
      Ok moves
    else
      let next_moves = get_next_moves cube in
      let cube_after_moves = List.fold_left make_move cube next_moves in
      solve_step_helper cube_after_moves (moves @ next_moves)
  in
  solve_step_helper cube []

let solve_cross =
  let error_condition = fun moves -> List.length moves > 100 in
  let error_msg =
    "Unable to solve cross: didn't find a solution with less than 100 moves."
  in
  solve_step error_condition error_msg cross_top_face_is_solved solve_cross_next_moves

let solve_corners_first_layer =
  let error_condition = fun moves -> List.length moves > 100 in
  let error_msg =
    "Unable to solve corners in the first layer: didn't find a solution with \
     less than 100 moves."
  in
  solve_step error_condition error_msg corners_top_layer_are_solved
    solve_corners_first_layer_next_moves

let solve_edges_second_layer =
  let error_condition = fun moves -> List.length moves > 100 in
  let error_msg =
    "Unable to solve edges in the second layer: didn't find a solution with \
     less than 100 moves."
  in
  solve_step error_condition error_msg edges_second_layer_are_solved
    solve_edges_second_layer_next_moves

let solve cube =
  Result.bind (solve_cross cube) (fun moves_to_solve_cross ->
      let cross_solved_cube = List.fold_left make_move cube moves_to_solve_cross in
      Result.bind (solve_corners_first_layer cross_solved_cube)
        (fun moves_to_solve_corners_first_layer ->
          let corners_first_layer_solved_cube = List.fold_left make_move cross_solved_cube moves_to_solve_corners_first_layer  in
          let flip_cube_moves =
            [
              { move_type = ROTATE_X; clockwise = true };
              { move_type = ROTATE_X; clockwise = true };
            ] in
          let cube_after_flip = List.fold_left make_move corners_first_layer_solved_cube flip_cube_moves in
          solve_edges_second_layer cube_after_flip
          |> Result.map (fun moves_to_solve_edges_second_layer ->
                 {
                   moves =
                     moves_to_solve_cross @ moves_to_solve_corners_first_layer
                     @ flip_cube_moves @ moves_to_solve_edges_second_layer;
                 })))
