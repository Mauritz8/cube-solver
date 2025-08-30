open Cube
open Move

let random_face_turn () =
  Random.self_init ();
  match Random.int 16 with
  | 0 -> UP_CLOCKWISE
  | 1 -> UP_COUNTER_CLOCKWISE
  | 2 -> UP_TWICE
  | 3 -> DOWN_CLOCKWISE
  | 4 -> DOWN_COUNTER_CLOCKWISE
  | 5 -> DOWN_TWICE
  | 6 -> RIGHT_CLOCKWISE
  | 7 -> RIGHT_COUNTER_CLOCKWISE
  | 8 -> RIGHT_TWICE
  | 9 -> LEFT_CLOCKWISE
  | 10 -> LEFT_COUNTER_CLOCKWISE
  | 11 -> LEFT_TWICE
  | 12 -> FRONT_CLOCKWISE
  | 13 -> FRONT_COUNTER_CLOCKWISE
  | 14 -> FRONT_TWICE
  | 15 -> BACK_CLOCKWISE
  | 16 -> BACK_COUNTER_CLOCKWISE
  | 17 -> BACK_TWICE
  | _ -> failwith "unreachable state"

let scramble () =
  let rec scramble_helper cube moves = function
    | 0 -> List.rev moves
    | n ->
        let move = random_face_turn () in
        let new_cube = make_move cube move in
        scramble_helper new_cube (move :: moves) (n - 1)
  in
  let scramble_moves = scramble_helper solved_cube [] 20 in
  Logs.info (fun m ->
      m "Generated scramble: %s" (moves_to_string scramble_moves));
  scramble_moves
