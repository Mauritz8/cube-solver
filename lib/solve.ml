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
  if
    cube.middle_layer.front.fst == cross_color
    && cube.middle_layer.left.trd == cube.middle_layer.left.snd
  then Ok [ { layer = LEFT; clockwise = false } ]
  else if
    cube.middle_layer.front.trd == cross_color
    && cube.middle_layer.right.fst == cube.middle_layer.right.snd
  then Ok [ { layer = RIGHT; clockwise = true } ]
  else if
    cube.middle_layer.right.fst == cross_color
    && cube.middle_layer.front.trd == cube.middle_layer.front.snd
  then Ok [ { layer = FRONT; clockwise = false } ]
  else if
    cube.middle_layer.right.trd == cross_color
    && cube.middle_layer.back.fst == cube.middle_layer.back.snd
  then Ok [ { layer = BACK; clockwise = true } ]
  else if
    cube.middle_layer.left.fst == cross_color
    && cube.middle_layer.back.trd == cube.middle_layer.back.snd
  then Ok [ { layer = BACK; clockwise = false } ]
  else if
    cube.middle_layer.left.trd == cross_color
    && cube.middle_layer.front.fst == cube.middle_layer.front.snd
  then Ok [ { layer = FRONT; clockwise = true } ]
  else if
    cube.middle_layer.back.fst == cross_color
    && cube.middle_layer.right.trd == cube.middle_layer.right.snd
  then Ok [ { layer = RIGHT; clockwise = false } ]
  else if
    cube.middle_layer.back.trd == cross_color
    && cube.middle_layer.left.fst == cube.middle_layer.left.snd
  then Ok [ { layer = LEFT; clockwise = true } ]
  else if cube.bottom_face.fst.snd == cross_color then
    let edge = cube.bottom_layer.front.snd in
    let center = cube.middle_layer.front.snd in
    if edge == center then Ok [ { layer = FRONT; clockwise = true } ]
    else Ok [ { layer = BOTTOM; clockwise = true } ]
  else if cube.bottom_face.snd.fst == cross_color then
    let edge = cube.bottom_layer.left.snd in
    let center = cube.middle_layer.left.snd in
    if edge == center then Ok [ { layer = LEFT; clockwise = true } ]
    else Ok [ { layer = BOTTOM; clockwise = true } ]
  else if cube.bottom_face.snd.trd == cross_color then
    let edge = cube.bottom_layer.right.snd in
    let center = cube.middle_layer.right.snd in
    if edge == center then Ok [ { layer = RIGHT; clockwise = true } ]
    else Ok [ { layer = BOTTOM; clockwise = true } ]
  else if cube.bottom_face.trd.snd == cross_color then
    let edge = cube.bottom_layer.back.snd in
    let center = cube.middle_layer.back.snd in
    if edge == center then Ok [ { layer = BACK; clockwise = true } ]
    else Ok [ { layer = BOTTOM; clockwise = true } ]
  else if cube.middle_layer.front.fst == cross_color then
    Ok
      [
        { layer = LEFT; clockwise = true };
        { layer = BOTTOM; clockwise = true };
        { layer = LEFT; clockwise = false };
      ]
  else if cube.middle_layer.front.trd == cross_color then
    Ok
      [
        { layer = RIGHT; clockwise = false };
        { layer = BOTTOM; clockwise = true };
        { layer = RIGHT; clockwise = true };
      ]
  else if cube.middle_layer.back.fst == cross_color then
    Ok
      [
        { layer = RIGHT; clockwise = true };
        { layer = BOTTOM; clockwise = true };
        { layer = RIGHT; clockwise = false };
      ]
  else if cube.middle_layer.back.trd == cross_color then
    Ok
      [
        { layer = LEFT; clockwise = false };
        { layer = BOTTOM; clockwise = true };
        { layer = LEFT; clockwise = true };
      ]
  else if cube.middle_layer.right.fst == cross_color then
    Ok
      [
        { layer = FRONT; clockwise = true };
        { layer = BOTTOM; clockwise = true };
        { layer = FRONT; clockwise = false };
      ]
  else if cube.middle_layer.right.trd == cross_color then
    Ok
      [
        { layer = BACK; clockwise = false };
        { layer = BOTTOM; clockwise = true };
        { layer = BACK; clockwise = true };
      ]
  else if cube.middle_layer.left.fst == cross_color then
    Ok
      [
        { layer = BACK; clockwise = true };
        { layer = BOTTOM; clockwise = true };
        { layer = BACK; clockwise = false };
      ]
  else if cube.middle_layer.left.trd == cross_color then
    Ok
      [
        { layer = FRONT; clockwise = false };
        { layer = BOTTOM; clockwise = true };
        { layer = FRONT; clockwise = true };
      ]
  else if
    cube.bottom_layer.front.snd == cross_color
    && cube.bottom_face.fst.snd == cube.middle_layer.front.snd
  then Ok [ { layer = FRONT; clockwise = true } ]
  else if
    cube.bottom_layer.right.snd == cross_color
    && cube.bottom_face.snd.trd == cube.middle_layer.right.snd
  then Ok [ { layer = RIGHT; clockwise = true } ]
  else if
    cube.bottom_layer.left.snd == cross_color
    && cube.bottom_face.snd.fst == cube.middle_layer.left.snd
  then Ok [ { layer = LEFT; clockwise = true } ]
  else if
    cube.bottom_layer.back.snd == cross_color
    && cube.bottom_face.trd.snd == cube.middle_layer.back.snd
  then Ok [ { layer = BACK; clockwise = true } ]
  else if
    cube.bottom_layer.front.snd == cross_color
    || cube.bottom_layer.right.snd == cross_color
    || cube.bottom_layer.left.snd == cross_color
    || cube.bottom_layer.back.snd == cross_color
  then Ok [ { layer = BOTTOM; clockwise = true } ]
  else if cube.top_layer.front.snd == cross_color then
    Ok [ { layer = FRONT; clockwise = true } ]
  else if cube.top_layer.back.snd == cross_color then
    Ok [ { layer = BACK; clockwise = true } ]
  else if cube.top_layer.right.snd == cross_color then
    Ok [ { layer = RIGHT; clockwise = true } ]
  else if cube.top_layer.left.snd == cross_color then
    Ok [ { layer = LEFT; clockwise = true } ]
  else if cube.top_face.fst.snd == cross_color then
    Ok [ { layer = BACK; clockwise = true } ]
  else if cube.top_face.snd.fst == cross_color then
    Ok [ { layer = LEFT; clockwise = true } ]
  else if cube.top_face.snd.trd == cross_color then
    Ok [ { layer = RIGHT; clockwise = true } ]
  else if cube.top_face.trd.snd == cross_color then
    Ok [ { layer = FRONT; clockwise = true } ]
  else Error "Unable to solve cross: didn't find an edge"

let solve_cross cube =
  let cross_color = WHITE in
  let rec solve_cross_helper cube moves =
    if List.length moves > 30 then
      Error
        "Unable to solve cross: didn't find a solution with less than 30 moves"
    else if cross_is_solved cube cross_color then
      Ok { cube; moves = List.map move_to_notation moves }
    else
      match solve_cross_next_moves cube cross_color with
      | Error e -> Error e
      | Ok next_moves ->
          let cube_apply_move cube move = make_move cube move in
          let cube_after_moves =
            List.fold_left cube_apply_move cube next_moves
          in
          solve_cross_helper cube_after_moves (List.append moves next_moves)
  in
  solve_cross_helper cube []
