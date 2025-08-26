open Ppx_yojson_conv_lib.Yojson_conv.Primitives
open Cube
open Move

type solution = { cube : cube; moves : string list } [@@deriving yojson]

let cross_is_solved cube cross_color =
  let cross_edges =
    [
      cube.top_face.fst.snd;
      cube.top_face.snd.fst;
      cube.top_face.snd.snd;
      cube.top_face.snd.trd;
      cube.top_face.trd.snd;
    ]
  in
  let is_cross_color sticker = sticker == cross_color in
  let is_cross = List.for_all is_cross_color cross_edges in
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
  let cross_color = WHITE in
  let rec solve_cross_helper cube moves =
    if List.length moves > 100 then
      Error
        "Unable to solve cross: didn't find a solution with less than 30 moves"
    else if cross_is_solved cube cross_color then
      Ok { cube; moves = List.map move_to_notation moves }
    else
      match solve_cross_next_moves cube cross_color with
      | Error e -> Error e
      | Ok next_moves ->
          let cube_after_moves = List.fold_left make_move cube next_moves in
          solve_cross_helper cube_after_moves (List.append moves next_moves)
  in
  solve_cross_helper cube []
