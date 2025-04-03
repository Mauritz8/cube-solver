open Cube
open Move

let rec solve_cross cube =
  let cross_color = WHITE in
  
  if cube.bottom_face.fst.snd == cross_color then 
    let move = { layer = FRONT; clockwise = true } in
    let cube2 = make_move cube move in
    let cube3 = make_move cube2 move in
    solve_cross cube3
  else if cube.bottom_face.snd.fst == cross_color then 
    let move = { layer = LEFT; clockwise = true } in
    let cube2 = make_move cube move in
    let cube3 = make_move cube2 move in
    solve_cross cube3
  else if cube.bottom_face.snd.trd == cross_color then 
    let move = { layer = RIGHT; clockwise = true } in
    let cube2 = make_move cube move in
    let cube3 = make_move cube2 move in
    solve_cross cube3
  else if cube.bottom_face.trd.snd == cross_color then 
    let move = { layer = BACK; clockwise = true } in
    let cube2 = make_move cube move in
    let cube3 = make_move cube2 move in
    solve_cross cube3

  else if cube.middle_layer.front.fst == cross_color then
    let cube2 = make_move cube { layer = LEFT; clockwise = true } in
    solve_cross cube2
  else if cube.middle_layer.front.trd == cross_color then
    let cube2 = make_move cube { layer = RIGHT; clockwise = false } in
    solve_cross cube2
  else if cube.middle_layer.back.fst == cross_color then
    let cube2 = make_move cube { layer = RIGHT; clockwise = true } in
    solve_cross cube2
  else if cube.middle_layer.back.trd == cross_color then
    let cube2 = make_move cube { layer = LEFT; clockwise = false } in
    solve_cross cube2
  else if cube.middle_layer.right.fst == cross_color then
    let cube2 = make_move cube { layer = FRONT; clockwise = true } in
    solve_cross cube2
  else if cube.middle_layer.right.trd == cross_color then
    let cube2 = make_move cube { layer = BACK; clockwise = false } in
    solve_cross cube2
  else if cube.middle_layer.left.fst == cross_color then
    let cube2 = make_move cube { layer = BACK; clockwise = true } in
    solve_cross cube2
  else if cube.middle_layer.left.trd == cross_color then
    let cube2 = make_move cube { layer = FRONT; clockwise = false } in
    solve_cross cube2

  else if cube.top_layer.front.snd == cross_color || cube.bottom_layer.front.snd == cross_color then
    let cube2 = make_move cube { layer = FRONT; clockwise = true } in
    solve_cross cube2
  else if cube.top_layer.back.snd == cross_color || cube.bottom_layer.back.snd == cross_color then
    let cube2 = make_move cube { layer = BACK; clockwise = true } in
    solve_cross cube2
  else if cube.top_layer.right.snd == cross_color || cube.bottom_layer.right.snd == cross_color then
    let cube2 = make_move cube { layer = RIGHT; clockwise = true } in
    solve_cross cube2
  else if cube.top_layer.left.snd == cross_color || cube.bottom_layer.left.snd == cross_color then
    let cube2 = make_move cube { layer = LEFT; clockwise = true } in
    solve_cross cube2
    
  else 
    cube
