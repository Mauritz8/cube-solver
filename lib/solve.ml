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
  List.for_all is_cross_color cross_edges

let solve_cross_next_moves cube cross_color =
  if cube.bottom_face.fst.snd == cross_color then
    let edge = cube.bottom_layer.front.snd in
    let center = cube.middle_layer.front.snd in
    if edge == center then
      let move = { layer = FRONT; clockwise = true } in
      [move; move]
    else [{ layer = BOTTOM; clockwise = true }]
  else if cube.bottom_face.snd.fst == cross_color then
    let edge = cube.bottom_layer.left.snd in
    let center = cube.middle_layer.left.snd in
    if edge == center then
      let move = { layer = LEFT; clockwise = true } in
      [move; move]
    else [{ layer = BOTTOM; clockwise = true }]
  else if cube.bottom_face.snd.trd == cross_color then
    let edge = cube.bottom_layer.right.snd in
    let center = cube.middle_layer.right.snd in
    if edge == center then
      let move = { layer = RIGHT; clockwise = true } in
      [move; move]
    else [{ layer = BOTTOM; clockwise = true }]
  else if cube.bottom_face.trd.snd == cross_color then
    let edge = cube.bottom_layer.back.snd in
    let center = cube.middle_layer.back.snd in
    if edge == center then
      let move = { layer = BACK; clockwise = true } in
      [move; move]
    else [{ layer = BOTTOM; clockwise = true }]
  else if cube.middle_layer.front.fst == cross_color then
    [{ layer = LEFT; clockwise = true }]
  else if cube.middle_layer.front.trd == cross_color then
    [{ layer = RIGHT; clockwise = false }]
  else if cube.middle_layer.back.fst == cross_color then
    [{ layer = RIGHT; clockwise = true }]
  else if cube.middle_layer.back.trd == cross_color then
    [{ layer = LEFT; clockwise = false }]
  else if cube.middle_layer.right.fst == cross_color then
    [{ layer = FRONT; clockwise = true }]
  else if cube.middle_layer.right.trd == cross_color then
    [{ layer = BACK; clockwise = false }]
  else if cube.middle_layer.left.fst == cross_color then
    [{ layer = BACK; clockwise = true }]
  else if cube.middle_layer.left.trd == cross_color then
    [{ layer = FRONT; clockwise = false }]
  else if
    cube.top_layer.front.snd == cross_color
    || cube.bottom_layer.front.snd == cross_color
  then [{ layer = FRONT; clockwise = true }]
  else if
    cube.top_layer.back.snd == cross_color
    || cube.bottom_layer.back.snd == cross_color
  then [{ layer = BACK; clockwise = true }]
  else if
    cube.top_layer.right.snd == cross_color
    || cube.bottom_layer.right.snd == cross_color
  then [{ layer = RIGHT; clockwise = true }]
  else if
    cube.top_layer.left.snd == cross_color
    || cube.bottom_layer.left.snd == cross_color
  then [{ layer = LEFT; clockwise = true }]
  else failwith "unable to solve cross"

let solve_cross cube =
  let cross_color = WHITE in
  let rec solve_cross_helper cube moves =
    if cross_is_solved cube cross_color then
      { cube = cube; moves = List.map move_to_notation moves }
    else
      let next_moves = solve_cross_next_moves cube cross_color in
      let cube_apply_move cube move = make_move cube move in
      let cube_after_moves = List.fold_left cube_apply_move cube next_moves in
      solve_cross_helper cube_after_moves (List.append moves next_moves)
  in
  solve_cross_helper cube []
