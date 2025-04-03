open Cube
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type layer = TOP | BOTTOM | RIGHT | LEFT | FRONT | BACK [@@deriving yojson]
type move = { layer : layer; clockwise : bool } [@@deriving yojson]
type moves = string list [@@deriving yojson]
type scramble = { new_cube : cube; moves : moves } [@@deriving yojson]

let rotate_face_clockwise face =
  {
    fst = {
      fst = face.trd.fst;
      snd = face.snd.fst;
      trd = face.fst.fst;
    };
    snd = {
      fst = face.trd.snd;
      snd = face.snd.snd;
      trd = face.fst.snd;
    };
    trd = {
      fst = face.trd.trd;
      snd = face.snd.trd;
      trd = face.fst.trd;
    };
  }

let rotate_face_counter_clockwise face =
  {
    fst = {
      fst = face.fst.trd;
      snd = face.snd.trd;
      trd = face.trd.trd;
    };
    snd = {
      fst = face.fst.snd;
      snd = face.snd.snd;
      trd = face.trd.snd;
    };
    trd = {
      fst = face.fst.fst;
      snd = face.snd.fst;
      trd = face.trd.fst;
    };
  }

let rotate_face face clockwise = 
  let rotate =
    if clockwise then rotate_face_clockwise
    else rotate_face_counter_clockwise
  in
  rotate face

let move_top_layer layer clockwise =
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

let move_bottom_layer layer clockwise =
  if clockwise then
    {
      front = layer.left;
      right = layer.front;
      back = layer.right;
      left = layer.back;
    }
  else
    {
      front = layer.right;
      right = layer.back;
      back = layer.left;
      left = layer.front;
    }

let move_top cube clockwise =
  { cube with
    top_face = rotate_face cube.top_face clockwise;
    top_layer = move_top_layer cube.top_layer clockwise;
  }

let move_bottom cube clockwise =
  { cube with
    bottom_face = rotate_face cube.bottom_face clockwise;
    bottom_layer = move_bottom_layer cube.bottom_layer clockwise;
  }

let move_right_clockwise cube =
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

let move_right_counter_clockwise cube =
  {
    top_face = {
      fst = { cube.top_face.fst with trd = cube.bottom_layer.back.fst; };
      snd = { cube.top_face.snd with trd = cube.middle_layer.back.fst; };
      trd = { cube.top_face.trd with trd = cube.top_layer.back.fst; };
    };
    top_layer = { cube.top_layer with
      front = { cube.top_layer.front with trd = cube.top_face.fst.trd; };
      back = { cube.top_layer.back with fst = cube.bottom_face.trd.trd; };
      right = {
        fst = cube.top_layer.right.trd;
        snd = cube.middle_layer.right.trd;
        trd = cube.bottom_layer.right.trd;
      };
    };
    middle_layer = { cube.middle_layer with
      front = { cube.middle_layer.front with trd = cube.top_face.snd.trd; };
      back = { cube.middle_layer.back with fst = cube.bottom_face.snd.trd; };
      right = {
        fst = cube.top_layer.right.snd;
        snd = cube.middle_layer.right.snd;
        trd = cube.bottom_layer.right.snd;
      };
    };
    bottom_layer = { cube.bottom_layer with
      front = { cube.bottom_layer.front with trd = cube.top_face.trd.trd; };
      back = { cube.bottom_layer.back with fst = cube.bottom_face.fst.trd; };
      right = {
        fst = cube.top_layer.right.fst;
        snd = cube.middle_layer.right.fst;
        trd = cube.bottom_layer.right.fst;
      };
    };
    bottom_face = {
      fst = { cube.bottom_face.fst with trd = cube.top_layer.front.trd; };
      snd = { cube.bottom_face.snd with trd = cube.middle_layer.front.trd; };
      trd = { cube.bottom_face.trd with trd = cube.bottom_layer.front.trd; };
    };
  }

let move_left_clockwise cube =
  {
    top_face = {
      fst = { cube.top_face.fst with fst = BLUE; };
      snd = { cube.top_face.snd with fst = ORANGE; };
      trd = { cube.top_face.trd with fst = ORANGE; };
    };
    top_layer = { cube.top_layer with
      front = { cube.top_layer.front with fst = WHITE; };
      left = { fst = ORANGE; snd = WHITE; trd = GREEN; };
      back = { cube.top_layer.back with trd = YELLOW; };
    };
    middle_layer = { cube.middle_layer with
      front = { cube.middle_layer.front with fst = BLUE; };
      left = { fst = GREEN; snd = ORANGE; trd = YELLOW; };
      back = { cube.middle_layer.back with trd = WHITE; };
    };
    bottom_layer = { cube.bottom_layer with
      front = { cube.bottom_layer.front with fst = YELLOW; };
      left = { fst = GREEN; snd = GREEN; trd = BLUE; };
      back = { cube.bottom_layer.back with trd = RED; };
    };
    bottom_face = {
      fst = { cube.bottom_face.fst with fst = RED; };
      snd = { cube.bottom_face.snd with fst = YELLOW; };
      trd = { cube.bottom_face.trd with fst = WHITE; };
    };
  }

let move_left_counter_clockwise cube =
  {
    top_face = {
      fst = { cube.top_face.fst with fst = RED; };
      snd = { cube.top_face.snd with fst = YELLOW; };
      trd = { cube.top_face.trd with fst = WHITE; };
    };
    top_layer = { cube.top_layer with
      front = { cube.top_layer.front with fst = RED; };
      left = { fst = BLUE; snd = GREEN; trd = GREEN; };
      back = { cube.top_layer.back with trd = YELLOW; };
    };
    middle_layer = { cube.middle_layer with
      front = { cube.middle_layer.front with fst = WHITE; };
      left = { fst = YELLOW; snd = ORANGE; trd = GREEN; };
      back = { cube.middle_layer.back with trd = BLUE; };
    };
    bottom_layer = { cube.bottom_layer with
      front = { cube.bottom_layer.front with fst = YELLOW; };
      left = { fst = GREEN; snd = WHITE; trd = ORANGE; };
      back = { cube.bottom_layer.back with trd = WHITE; };
    };
    bottom_face = {
      fst = { cube.bottom_face.fst with fst = BLUE; };
      snd = { cube.bottom_face.snd with fst = ORANGE; };
      trd = { cube.bottom_face.trd with fst = ORANGE; };
    };
  }

let move_front_clockwise cube =
  {
    top_face = { cube.top_face with
      trd = { fst = GREEN; snd = GREEN; trd = BLUE; };
    };
    top_layer = { cube.top_layer with
      front = { fst = WHITE; snd = YELLOW; trd = RED; };
      left = { cube.top_layer.left with trd = RED; };
      right = { cube.top_layer.right with fst = YELLOW; };
    };
    middle_layer = { cube.middle_layer with
      front = { fst = BLUE; snd = GREEN; trd = BLUE; };
      left = { cube.middle_layer.left with trd = RED; };
      right = { cube.middle_layer.right with fst = ORANGE; };
    };
    bottom_layer = { cube.bottom_layer with
      front = { fst = YELLOW; snd = ORANGE; trd = RED; };
      left = { cube.bottom_layer.left with trd = GREEN; };
      right = { cube.bottom_layer.right with fst = YELLOW; };
    };
    bottom_face = { cube.bottom_face with
      fst = { fst = ORANGE; snd = YELLOW; trd = GREEN; };
    };
  }

let move_front_counter_clockwise cube =
  {
    top_face = { cube.top_face with
      trd = { fst = GREEN; snd = YELLOW; trd = ORANGE; };
    };
    top_layer = { cube.top_layer with
      front = { fst = RED; snd = ORANGE; trd = YELLOW; };
      left = { cube.top_layer.left with trd = YELLOW; };
      right = { cube.top_layer.right with fst = GREEN; };
    };
    middle_layer = { cube.middle_layer with
      front = { fst = BLUE; snd = GREEN; trd = BLUE; };
      left = { cube.middle_layer.left with trd = ORANGE; };
      right = { cube.middle_layer.right with fst = RED; };
    };
    bottom_layer = { cube.bottom_layer with
      front = { fst = RED; snd = YELLOW; trd = WHITE; };
      left = { cube.bottom_layer.left with trd = YELLOW; };
      right = { cube.bottom_layer.right with fst = RED; };
    };
    bottom_face = { cube.bottom_face with
      fst = { fst = BLUE; snd = GREEN; trd = GREEN; };
    };
  }

let move_back_clockwise cube =
  {
    top_face = { cube.top_face with
      fst = { fst = BLUE; snd = YELLOW; trd = BLUE; };
    };
    top_layer = { cube.top_layer with
      back = { fst = WHITE; snd = RED; trd = WHITE; };
      left = { cube.top_layer.left with fst = RED; };
      right = { cube.top_layer.right with trd = ORANGE; };
    };
    middle_layer = { cube.middle_layer with
      back = { fst = BLUE; snd = BLUE; trd = RED; };
      left = { cube.middle_layer.left with fst = GREEN; };
      right = { cube.middle_layer.right with trd = WHITE; };
    };
    bottom_layer = { cube.bottom_layer with
      back = { fst = BLUE; snd = ORANGE; trd = ORANGE; };
      left = { cube.bottom_layer.left with fst = WHITE; };
      right = { cube.bottom_layer.right with trd = YELLOW; };
    };
    bottom_face = { cube.bottom_face with
      trd = { fst = GREEN; snd = WHITE; trd = ORANGE; };
    };
  }

let move_back_counter_clockwise cube =
  {
    top_face = { cube.top_face with
      fst = { fst = ORANGE; snd = WHITE; trd = GREEN; };
    };
    top_layer = { cube.top_layer with
      back = { fst = ORANGE; snd = ORANGE; trd = BLUE; };
      left = { cube.top_layer.left with fst = YELLOW; };
      right = { cube.top_layer.right with trd = WHITE; };
    };
    middle_layer = { cube.middle_layer with
      back = { fst = RED; snd = BLUE; trd = BLUE; };
      left = { cube.middle_layer.left with fst = WHITE; };
      right = { cube.middle_layer.right with trd = GREEN; };
    };
    bottom_layer = { cube.bottom_layer with
      back = { fst = WHITE; snd = RED; trd = WHITE; };
      left = { cube.bottom_layer.left with fst = ORANGE; };
      right = { cube.bottom_layer.right with trd = RED; };
    };
    bottom_face = { cube.bottom_face with
      trd = { fst = BLUE; snd = YELLOW; trd = BLUE; };
    };
  }

let make_move cube move =
  match move.layer, move.clockwise with
  | TOP, _ -> move_top cube move.clockwise
  | BOTTOM, _ -> move_bottom cube move.clockwise
  | RIGHT, true -> move_right_clockwise cube
  | RIGHT, false -> move_right_counter_clockwise cube
  | LEFT, true -> move_left_clockwise cube
  | LEFT, false -> move_left_counter_clockwise cube
  | FRONT, true -> move_front_clockwise cube
  | FRONT, false -> move_front_counter_clockwise cube
  | BACK, true -> move_back_clockwise cube
  | BACK, false -> move_back_counter_clockwise cube


(* TODO: move scramble related functions to its own library *)
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
