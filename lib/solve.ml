open Cube
open Move

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

let rec solve_cross cube =
  let cross_color = WHITE in
  if cross_is_solved cube cross_color then cube
  else
    let cube_after_move =
      if cube.bottom_face.fst.snd == cross_color then
        let edge = cube.bottom_layer.front.snd in
        let center = cube.middle_layer.front.snd in
        if edge == center then
          let move = { layer = FRONT; clockwise = true } in
          let cube2 = make_move cube move in
          make_move cube2 move
        else
          make_move cube { layer = BOTTOM; clockwise = true }
      else if cube.bottom_face.snd.fst == cross_color then
        let edge = cube.bottom_layer.left.snd in
        let center = cube.middle_layer.left.snd in
        if edge == center then
          let move = { layer = LEFT; clockwise = true } in
          let cube2 = make_move cube move in
          make_move cube2 move
        else
          make_move cube { layer = BOTTOM; clockwise = true }
      else if cube.bottom_face.snd.trd == cross_color then
        let edge = cube.bottom_layer.right.snd in
        let center = cube.middle_layer.right.snd in
        if edge == center then
          let move = { layer = RIGHT; clockwise = true } in
          let cube2 = make_move cube move in
          make_move cube2 move
        else
          make_move cube { layer = BOTTOM; clockwise = true }
      else if cube.bottom_face.trd.snd == cross_color then
        let edge = cube.bottom_layer.back.snd in
        let center = cube.middle_layer.back.snd in
        if edge == center then
          let move = { layer = BACK; clockwise = true } in
          let cube2 = make_move cube move in
          make_move cube2 move
        else
          make_move cube { layer = BOTTOM; clockwise = true }
      else if cube.middle_layer.front.fst == cross_color then
        make_move cube { layer = LEFT; clockwise = true }
      else if cube.middle_layer.front.trd == cross_color then
        make_move cube { layer = RIGHT; clockwise = false }
      else if cube.middle_layer.back.fst == cross_color then
        make_move cube { layer = RIGHT; clockwise = true }
      else if cube.middle_layer.back.trd == cross_color then
        make_move cube { layer = LEFT; clockwise = false }
      else if cube.middle_layer.right.fst == cross_color then
        make_move cube { layer = FRONT; clockwise = true }
      else if cube.middle_layer.right.trd == cross_color then
        make_move cube { layer = BACK; clockwise = false }
      else if cube.middle_layer.left.fst == cross_color then
        make_move cube { layer = BACK; clockwise = true }
      else if cube.middle_layer.left.trd == cross_color then
        make_move cube { layer = FRONT; clockwise = false }
      else if
        cube.top_layer.front.snd == cross_color
        || cube.bottom_layer.front.snd == cross_color
      then make_move cube { layer = FRONT; clockwise = true }
      else if
        cube.top_layer.back.snd == cross_color
        || cube.bottom_layer.back.snd == cross_color
      then make_move cube { layer = BACK; clockwise = true }
      else if
        cube.top_layer.right.snd == cross_color
        || cube.bottom_layer.right.snd == cross_color
      then make_move cube { layer = RIGHT; clockwise = true }
      else if
        cube.top_layer.left.snd == cross_color
        || cube.bottom_layer.left.snd == cross_color
      then make_move cube { layer = LEFT; clockwise = true }
      else failwith "unable to solve cross"
    in
    solve_cross cube_after_move
