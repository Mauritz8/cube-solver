open Cube
open Move

type edge = { face : face; index : int }

let edge_to_string edge = Printf.sprintf
  "{ face = %s; index = %d }"
  (face_to_string edge.face)
  edge.index

let face_stickers cube = function
  | FRONT -> cube.front
  | BACK -> cube.back
  | RIGHT -> cube.right
  | LEFT -> cube.left
  | TOP -> cube.top
  | BOTTOM -> cube.bottom

let find_edges_face face =
  let is_odd i _ = i mod 2 != 0 in
  List.filteri is_odd (snd face)

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
  (fst face, face_index)

let find_all_edges_cube color cube = 
  let faces = [
    (FRONT, cube.front); (BACK, cube.back); (RIGHT, cube.right);
    (LEFT, cube.left); (BOTTOM, cube.bottom); (TOP, cube.top)] in
  let edges = List.map (find_edge_face color) faces in
  let found_edges = List.filter
    (fun edge -> (Option.is_some (snd edge)))
    edges
  in
  List.map
    (fun edge -> { face = fst edge; index = Option.get (snd edge) })
    found_edges

let find_edge_cube color cube =
  let edges = find_all_edges_cube color cube in
  let () = List.iter (fun edge -> Printf.printf "%s " (edge_to_string edge)) edges in
  let () = print_newline () in
  List.hd edges

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
  Printf.printf "%s\n" (sticker_to_string color);
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
  let cross_edges = 1 in
  solve_cross_helper cube cross_edges

