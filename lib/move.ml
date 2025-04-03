open Cube
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type layer = TOP | BOTTOM | RIGHT | LEFT | FRONT | BACK [@@deriving yojson]
type move = { layer : layer; clockwise : bool } [@@deriving yojson]
type moves = string list [@@deriving yojson]
type scramble = { new_cube : cube; moves : moves } [@@deriving yojson]

let rotate_face face _ = face

let move_layer layer clockwise =
  if clockwise then
    {
      front = layer.right;
      right = layer.back;
      back = layer.left;
      left = layer.front;
    }
  else
    {
      front = layer.left;
      right = layer.front;
      back = layer.right;
      left = layer.back;
    }

let move_top cube clockwise =
  { cube with
    top_face = rotate_face cube.top_face clockwise;
    top_layer = move_layer cube.top_layer clockwise;
  }

let move_bottom cube clockwise =
  { cube with
    bottom_face = rotate_face cube.bottom_face clockwise;
    bottom_layer = move_layer cube.bottom_layer clockwise;
  }

let move_right cube _ =
  {
    top_face = {
      fst = { cube.top_face.fst with trd = cube.top_layer.front.trd }; 
      snd = { cube.top_face.snd with trd = cube.middle_layer.front.trd }; 
      trd = { cube.top_face.trd with trd = cube.bottom_layer.front.trd }; 
    };
    top_layer = { cube.top_layer with
      front = { cube.top_layer.front with trd = cube.bottom_face.fst.trd };
      back = { cube.top_layer.back with fst = cube.top_face.trd.trd };
      right = {
        fst = cube.bottom_layer.right.fst;
        snd = cube.middle_layer.right.fst;
        trd = cube.top_layer.right.fst;
      };
    };
    middle_layer = { cube.middle_layer with
      front = { cube.middle_layer.front with trd = cube.bottom_face.snd.trd };
      back = { cube.middle_layer.back with fst = cube.top_face.snd.trd };
      right = { cube.middle_layer.right with
        fst = cube.bottom_layer.right.snd;
        trd = cube.top_layer.right.snd;
      };
    };
    bottom_layer = { cube.bottom_layer with
      front = { cube.bottom_layer.front with trd = cube.bottom_face.trd.trd };
      back = { cube.bottom_layer.back with fst = cube.top_face.fst.trd };
      right = {
        fst = cube.bottom_layer.right.trd;
        snd = cube.middle_layer.right.trd;
        trd = cube.top_layer.right.trd;
      };
    };
    bottom_face = {
      fst = { cube.bottom_face.fst with trd = cube.bottom_layer.back.fst }; 
      snd = { cube.bottom_face.snd with trd = cube.middle_layer.back.fst }; 
      trd = { cube.bottom_face.trd with trd = cube.top_layer.back.fst }; 
    };
  }


let move_left cube _ = cube

let move_front cube _ = cube

let move_back cube _ = cube

let make_move cube move =
  let f g = g cube move.clockwise in
  match move.layer with
  | TOP -> f move_top
  | BOTTOM -> f move_bottom
  | RIGHT -> f move_right
  | LEFT -> f move_left
  | FRONT -> f move_front
  | BACK -> f move_back

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

let random_move () =
  { layer = random_layer (); clockwise = random_bool () }

let move_to_notation move =
  String.cat
    (match move.layer with
    | TOP -> "U"
    | BOTTOM -> "D"
    | RIGHT -> "R"
    | LEFT -> "L"
    | FRONT -> "F"
    | BACK -> "B")
    (if move.clockwise then "" else "'")

let moves_string moves = String.concat " " (List.map move_to_notation moves)

let scramble () =
  let rec scramble_helper cube moves = function
    | 0 -> { new_cube = cube; moves = List.rev moves }
    | n ->
      let move = random_move () in
      let new_cube = make_move cube move in
      scramble_helper new_cube ((move_to_notation move) :: moves) (n - 1)
  in
  scramble_helper solved_cube [] 20
