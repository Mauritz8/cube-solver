open Cube
open Move

let rec solve_cross cube =
  let cross_color = WHITE in
  if cube.bottom_face.fst.snd == cross_color then 
    let move = { layer = FRONT; clockwise = true } in
    let cube2 = Move.make_move cube move in
    let cube3 = Move.make_move cube2 move in
    solve_cross cube3
  else if cube.bottom_face.snd.fst == cross_color then 
    let move = { layer = LEFT; clockwise = true } in
    let cube2 = Move.make_move cube move in
    let cube3 = Move.make_move cube2 move in
    solve_cross cube3
  else if cube.bottom_face.snd.trd == cross_color then 
    let move = { layer = RIGHT; clockwise = true } in
    let cube2 = Move.make_move cube move in
    let cube3 = Move.make_move cube2 move in
    solve_cross cube3
  else if cube.bottom_face.trd.snd == cross_color then 
    let move = { layer = BACK; clockwise = true } in
    let cube2 = Move.make_move cube move in
    let cube3 = Move.make_move cube2 move in
    solve_cross cube3
  else 
    cube
