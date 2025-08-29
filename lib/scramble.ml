open Cube
open Move

let random_face_turn () =
  Random.self_init ();
  match Random.int 16 with
  | 0 -> UP_CLOCKWISE
  | 1 -> UP_COUNTER_CLOCKWISE
  | 2 -> DOWN_CLOCKWISE
  | 3 -> DOWN_COUNTER_CLOCKWISE
  | 4 -> RIGHT_CLOCKWISE
  | 5 -> RIGHT_COUNTER_CLOCKWISE
  | 6 -> LEFT_CLOCKWISE
  | 7 -> LEFT_COUNTER_CLOCKWISE
  | 8 -> FRONT_CLOCKWISE
  | 9 -> FRONT_COUNTER_CLOCKWISE
  | 10 -> BACK_CLOCKWISE
  | 11 -> BACK_COUNTER_CLOCKWISE
  | 12 -> ROTATE_Y_CLOCKWISE
  | 13 -> ROTATE_Y_COUNTER_CLOCKWISE
  | 14 -> ROTATE_X_CLOCKWISE
  | 15 -> ROTATE_X_COUNTER_CLOCKWISE
  | _ -> failwith "unreachable state"

let scramble () =
  let rec scramble_helper cube moves = function
    | 0 -> List.rev moves
    | n ->
        let move = random_face_turn () in
        let new_cube = make_move cube move in
        scramble_helper new_cube (move :: moves) (n - 1)
  in
  scramble_helper solved_cube [] 20
