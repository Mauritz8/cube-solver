open Ppx_yojson_conv_lib.Yojson_conv.Primitives
open Cube
open Move

type solution = { moves : string list } [@@deriving yojson]
type sub_solution = { cube : cube; moves : string list }

let cross_is_solved cube =
  let is_cross =
    cube.top_face.snd.snd == cube.top_face.fst.snd
    && cube.top_face.snd.snd == cube.top_face.snd.fst
    && cube.top_face.snd.snd == cube.top_face.snd.trd
    && cube.top_face.snd.snd == cube.top_face.trd.snd
  in
  let is_matching_edges =
    cube.top_layer.front.snd == cube.middle_layer.front.snd
    && cube.top_layer.right.snd == cube.middle_layer.right.snd
    && cube.top_layer.left.snd == cube.middle_layer.left.snd
    && cube.top_layer.back.snd == cube.middle_layer.back.snd
  in
  is_cross && is_matching_edges

let solve_cross_next_moves cube cross_color =
  if cube.bottom_face.fst.snd == cross_color then
    let is_matching_edge =
      cube.bottom_layer.front.snd == cube.middle_layer.front.snd
    in
    if is_matching_edge then
      Ok
        [
          { move_type = FRONT; clockwise = true };
          { move_type = FRONT; clockwise = true };
        ]
    else Ok [ { move_type = DOWN; clockwise = true } ]
  else if cube.middle_layer.front.fst == cross_color then
    let is_matching_edge =
      cube.middle_layer.left.trd == cube.middle_layer.left.snd
    in
    if is_matching_edge then Ok [ { move_type = LEFT; clockwise = false } ]
    else
      Ok
        [
          { move_type = LEFT; clockwise = true };
          { move_type = DOWN; clockwise = true };
          { move_type = LEFT; clockwise = false };
        ]
  else if cube.middle_layer.front.trd == cross_color then
    let is_matching_edge =
      cube.middle_layer.right.fst == cube.middle_layer.right.snd
    in
    if is_matching_edge then Ok [ { move_type = RIGHT; clockwise = true } ]
    else
      Ok
        [
          { move_type = RIGHT; clockwise = false };
          { move_type = DOWN; clockwise = true };
          { move_type = RIGHT; clockwise = true };
        ]
  else if
    cube.top_face.trd.snd == cross_color
    && cube.top_layer.front.snd != cube.middle_layer.front.snd
  then
    Ok
      [
        { move_type = FRONT; clockwise = true };
        { move_type = FRONT; clockwise = true };
        { move_type = DOWN; clockwise = true };
      ]
  else if cube.top_layer.front.snd == cross_color then
    Ok [ { move_type = FRONT; clockwise = true } ]
  else if cube.bottom_layer.front.snd == cross_color then
    Ok [ { move_type = FRONT; clockwise = true } ]
  else Ok [ { move_type = ROTATE_Y; clockwise = true } ]

let solve_cross cube =
  let rec solve_cross_helper cube moves =
    if List.length moves > 100 then
      Error
        "Unable to solve cross: didn't find a solution with less than 100 moves"
    else if cross_is_solved cube then
      Ok { cube; moves = List.map move_to_notation moves }
    else
      let cross_color = cube.top_face.snd.snd in
      match solve_cross_next_moves cube cross_color with
      | Error e -> Error e
      | Ok next_moves ->
          let cube_after_moves = List.fold_left make_move cube next_moves in
          solve_cross_helper cube_after_moves (List.append moves next_moves)
  in
  solve_cross_helper cube []

let corners_first_layer_solved cube =
  let corners_inserted =
    cube.top_face.snd.snd == cube.top_face.fst.fst
    && cube.top_face.snd.snd == cube.top_face.fst.trd
    && cube.top_face.snd.snd == cube.top_face.trd.fst
    && cube.top_face.snd.snd == cube.top_face.trd.trd
  in
  let is_matching_edges =
    cube.top_layer.front.fst == cube.middle_layer.front.snd
    && cube.top_layer.front.trd == cube.middle_layer.front.snd
    && cube.top_layer.right.fst == cube.middle_layer.right.snd
    && cube.top_layer.right.trd == cube.middle_layer.right.snd
    && cube.top_layer.left.fst == cube.middle_layer.left.snd
    && cube.top_layer.left.trd == cube.middle_layer.left.snd
    && cube.top_layer.back.fst == cube.middle_layer.back.snd
    && cube.top_layer.back.trd == cube.middle_layer.back.snd
  in
  corners_inserted && is_matching_edges

let solve_corners_first_layer_next_moves cube =
  let cross_color = cube.top_face.snd.snd in
  if cube.bottom_layer.front.fst == cross_color then
    let in_right_position =
      cube.bottom_layer.left.trd == cube.middle_layer.left.snd
    in
    if in_right_position then
      Ok
        [
          { move_type = DOWN; clockwise = true };
          { move_type = LEFT; clockwise = true };
          { move_type = DOWN; clockwise = false };
          { move_type = LEFT; clockwise = false };
        ]
    else Ok [ { move_type = DOWN; clockwise = true } ]
  else if cube.bottom_layer.front.trd == cross_color then
    let in_right_position =
      cube.bottom_layer.right.fst == cube.middle_layer.right.snd
    in
    if in_right_position then
      Ok
        [
          { move_type = DOWN; clockwise = false };
          { move_type = RIGHT; clockwise = false };
          { move_type = DOWN; clockwise = true };
          { move_type = RIGHT; clockwise = true };
        ]
    else Ok [ { move_type = DOWN; clockwise = true } ]
  else if
    cube.top_layer.front.fst == cross_color
    || cube.top_face.trd.fst == cross_color
       && cube.top_layer.front.fst <> cube.top_layer.front.snd
  then
    Ok
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
    Ok
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
      Ok
        [
          { move_type = DOWN; clockwise = true };
          { move_type = LEFT; clockwise = true };
          { move_type = DOWN; clockwise = true };
          { move_type = DOWN; clockwise = true };
          { move_type = LEFT; clockwise = false };
        ]
    else Ok [ { move_type = DOWN; clockwise = true } ]
  else if cube.bottom_face.fst.trd == cross_color then
    let in_right_position =
      cube.bottom_layer.right.fst == cube.middle_layer.front.snd
    in
    if in_right_position then
      Ok
        [
          { move_type = DOWN; clockwise = false };
          { move_type = RIGHT; clockwise = false };
          { move_type = DOWN; clockwise = true };
          { move_type = DOWN; clockwise = true };
          { move_type = RIGHT; clockwise = true };
        ]
    else Ok [ { move_type = DOWN; clockwise = true } ]
  else Ok [ { move_type = ROTATE_Y; clockwise = true } ]

let solve_corners_first_layer cube =
  let rec solve_corners_first_layer_helper cube moves =
    if List.length moves > 100 then
      Error
        "Unable to solve corners in first layer: didn't find a solution with \
         less than 100 moves"
    else if corners_first_layer_solved cube then
      Ok { cube; moves = List.map move_to_notation moves }
    else
      match solve_corners_first_layer_next_moves cube with
      | Error e -> Error e
      | Ok next_moves ->
          let cube_after_moves = List.fold_left make_move cube next_moves in
          solve_corners_first_layer_helper cube_after_moves
            (List.append moves next_moves)
  in
  solve_corners_first_layer_helper cube []

let solve cube =
  Result.bind (solve_cross cube) (fun cross_solution ->
      solve_corners_first_layer cross_solution.cube
      |> Result.map (fun corners_first_layer_solution ->
             {
               moves = cross_solution.moves @ corners_first_layer_solution.moves;
             }))
