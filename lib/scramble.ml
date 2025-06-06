open Ppx_yojson_conv_lib.Yojson_conv.Primitives
open Cube
open Move

type scramble = { new_cube : cube; moves : string list } [@@deriving yojson]

let random_layer () =
  Random.self_init ();
  match Random.int 6 with
  | 0 -> TOP
  | 1 -> BOTTOM
  | 2 -> RIGHT
  | 3 -> LEFT
  | 4 -> FRONT
  | 5 -> BACK
  | _ -> failwith "unreachable state"

let random_bool () =
  Random.self_init ();
  if Random.int 2 = 0 then false else true

let random_move () = { layer = random_layer (); clockwise = random_bool () }

let scramble () =
  let rec scramble_helper cube moves = function
    | 0 -> { new_cube = cube; moves = List.rev moves }
    | n ->
        let move = random_move () in
        let new_cube = make_move cube move in
        scramble_helper new_cube (move_to_notation move :: moves) (n - 1)
  in
  scramble_helper solved_cube [] 20
