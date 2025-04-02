open Cube
open Move

type edge = { face : face; index : int }

let face_stickers cube = function
  | FRONT -> cube.front
  | BACK -> cube.back
  | RIGHT -> cube.right
  | LEFT -> cube.left
  | TOP -> cube.top
  | BOTTOM -> cube.bottom

let find_edges_face stickers =
  let is_odd i _ = i mod 2 != 0 in
  List.filteri is_odd stickers

let find_edge_face color face = 
  let edges = find_edges_face face in
  let is_color sticker = sticker == color in
  let edge_index = List.find_index is_color edges in
  let face_index = match edge_index with
    | Some 0 -> Some 1
    | Some 1 -> Some 3
    | Some 2 -> Some 5
    | Some 3 -> Some 7
    | _ -> None
  in
  face_index

let find_edge_cube color cube = 
  let faces = [ FRONT; BACK; RIGHT; LEFT; BOTTOM; TOP ] in
  let faces_stickers = [ cube.front; cube.back; cube.right; cube.left; cube.bottom; cube.top ] in
  let edges = List.map (find_edge_face color) faces_stickers in
  let edge = Option.get (List.find Option.is_some edges) in
  { face = List.nth faces edge; index = edge }

let rec move_edge_to_top edge cube = 
  match edge.index with
    | 1 | 7 ->
        let new_cube = Move.make_move
          cube
          { face = edge.face; clockwise = edge.index == 1 }
        in
        move_edge_to_top { edge with index = 5 } new_cube
    | 3 -> (match edge.face with
      | FRONT -> make_move cube { face = LEFT; clockwise = false }
      | BACK -> make_move cube { face = RIGHT; clockwise = false }
      | RIGHT -> make_move cube { face = FRONT; clockwise = false }
      | LEFT -> make_move cube { face = BACK; clockwise = false }
      | TOP -> cube
      | BOTTOM ->
          let move = { face = LEFT; clockwise = false } in
          let new_cube = make_move cube move in
          make_move new_cube move)
    | 5 -> (match edge.face with
      | FRONT -> make_move cube { face = RIGHT; clockwise = true }
      | BACK -> make_move cube { face = LEFT; clockwise = true }
      | RIGHT -> make_move cube { face = BACK; clockwise = true }
      | LEFT -> make_move cube { face = FRONT; clockwise = true }
      | TOP -> cube
      | BOTTOM ->
          let move = { face = RIGHT; clockwise = true } in
          let new_cube = make_move cube move in
          make_move new_cube move)
    | _ -> invalid_arg "edge invalid index"

let solve_edge edge cube = move_edge_to_top edge cube

let solve_cross cube = 
  let face = TOP in
  let face_stickers = face_stickers cube face in
  let color = List.nth face_stickers 4 in
  let rec solve_cross_helper cube = function
    | 0 -> cube
    | n ->
      let edge = find_edge_cube color cube in
      let () = match edge.face with
      | TOP -> print_endline "top"
      | BOTTOM -> print_endline "bottom"
      | RIGHT -> print_endline "right"
      | LEFT -> print_endline "left"
      | FRONT -> print_endline "front"
      | BACK -> print_endline "back"
      in
      Printf.printf "edge index = %d\n" edge.index;
      let new_cube = solve_edge edge cube in
      solve_cross_helper new_cube (n - 1)
  in
  let cross_edges = 4 in
  solve_cross_helper cube cross_edges

