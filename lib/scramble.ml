open Cube
open Move

let random_face_turn () =
  Random.self_init ();
  match Random.int 6 with
  | 0 -> UP
  | 1 -> DOWN
  | 2 -> RIGHT
  | 3 -> LEFT
  | 4 -> FRONT
  | 5 -> BACK
  | _ -> failwith "unreachable state"

let random_bool () =
  Random.self_init ();
  if Random.int 2 = 0 then false else true

let random_face_turn () =
  { move_type = random_face_turn (); clockwise = random_bool () }

let scramble () =
  let rec scramble_helper cube moves = function
    | 0 -> List.rev moves
    | n ->
        let move = random_face_turn () in
        let new_cube = make_move cube move in
        scramble_helper new_cube (move :: moves) (n - 1)
  in
  scramble_helper solved_cube [] 20
