type sticker = YELLOW | WHITE | BLUE | RED | GREEN | ORANGE
[@@deriving yojson]

type sticker_row = { fst : sticker; snd : sticker; trd : sticker }
[@@deriving yojson]

type layer = {
  front : sticker_row;
  right : sticker_row;
  back : sticker_row;
  left : sticker_row;
}
[@@deriving yojson]

type face = { fst : sticker_row; snd : sticker_row; trd : sticker_row }
[@@deriving yojson]

(* TODO: consider if arrays of length three are better than structs *)
type cube = {
  top_face : face;
  top_layer : layer;
  middle_layer : layer;
  bottom_layer : layer;
  bottom_face : face;
}
[@@deriving yojson]

let solved_cube_layer =
  {
    front = { fst = GREEN; snd = GREEN; trd = GREEN };
    right = { fst = RED; snd = RED; trd = RED };
    back = { fst = BLUE; snd = BLUE; trd = BLUE };
    left = { fst = ORANGE; snd = ORANGE; trd = ORANGE };
  }

let solved_cube =
  {
    top_face =
      {
        fst = { fst = WHITE; snd = WHITE; trd = WHITE };
        snd = { fst = WHITE; snd = WHITE; trd = WHITE };
        trd = { fst = WHITE; snd = WHITE; trd = WHITE };
      };
    top_layer = solved_cube_layer;
    middle_layer = solved_cube_layer;
    bottom_layer = solved_cube_layer;
    bottom_face =
      {
        fst = { fst = YELLOW; snd = YELLOW; trd = YELLOW };
        snd = { fst = YELLOW; snd = YELLOW; trd = YELLOW };
        trd = { fst = YELLOW; snd = YELLOW; trd = YELLOW };
      };
  }

let sticker_to_string = function
  | YELLOW -> "Y"
  | WHITE -> "W"
  | BLUE -> "B"
  | RED -> "R"
  | GREEN -> "G"
  | ORANGE -> "O"

let cube_to_string cube =
  Printf.sprintf
    "\n\
    \         %s %s %s\n\
    \         %s %s %s\n\
    \         %s %s %s\n\n\
    \  %s %s %s  %s %s %s  %s %s %s  %s %s %s\n\
    \  %s %s %s  %s %s %s  %s %s %s  %s %s %s\n\
    \  %s %s %s  %s %s %s  %s %s %s  %s %s %s\n\n\
    \         %s %s %s\n\
    \         %s %s %s\n\
    \         %s %s %s\n\
    \  "
    (sticker_to_string cube.top_face.fst.fst)
    (sticker_to_string cube.top_face.fst.snd)
    (sticker_to_string cube.top_face.fst.trd)
    (sticker_to_string cube.top_face.snd.fst)
    (sticker_to_string cube.top_face.snd.snd)
    (sticker_to_string cube.top_face.snd.trd)
    (sticker_to_string cube.top_face.trd.fst)
    (sticker_to_string cube.top_face.trd.snd)
    (sticker_to_string cube.top_face.trd.trd)
    (sticker_to_string cube.top_layer.left.fst)
    (sticker_to_string cube.top_layer.left.snd)
    (sticker_to_string cube.top_layer.left.trd)
    (sticker_to_string cube.top_layer.front.fst)
    (sticker_to_string cube.top_layer.front.snd)
    (sticker_to_string cube.top_layer.front.trd)
    (sticker_to_string cube.top_layer.right.fst)
    (sticker_to_string cube.top_layer.right.snd)
    (sticker_to_string cube.top_layer.right.trd)
    (sticker_to_string cube.top_layer.back.fst)
    (sticker_to_string cube.top_layer.back.snd)
    (sticker_to_string cube.top_layer.back.trd)
    (sticker_to_string cube.middle_layer.left.fst)
    (sticker_to_string cube.middle_layer.left.snd)
    (sticker_to_string cube.middle_layer.left.trd)
    (sticker_to_string cube.middle_layer.front.fst)
    (sticker_to_string cube.middle_layer.front.snd)
    (sticker_to_string cube.middle_layer.front.trd)
    (sticker_to_string cube.middle_layer.right.fst)
    (sticker_to_string cube.middle_layer.right.snd)
    (sticker_to_string cube.middle_layer.right.trd)
    (sticker_to_string cube.middle_layer.back.fst)
    (sticker_to_string cube.middle_layer.back.snd)
    (sticker_to_string cube.middle_layer.back.trd)
    (sticker_to_string cube.bottom_layer.left.fst)
    (sticker_to_string cube.bottom_layer.left.snd)
    (sticker_to_string cube.bottom_layer.left.trd)
    (sticker_to_string cube.bottom_layer.front.fst)
    (sticker_to_string cube.bottom_layer.front.snd)
    (sticker_to_string cube.bottom_layer.front.trd)
    (sticker_to_string cube.bottom_layer.right.fst)
    (sticker_to_string cube.bottom_layer.right.snd)
    (sticker_to_string cube.bottom_layer.right.trd)
    (sticker_to_string cube.bottom_layer.back.fst)
    (sticker_to_string cube.bottom_layer.back.snd)
    (sticker_to_string cube.bottom_layer.back.trd)
    (sticker_to_string cube.bottom_face.fst.fst)
    (sticker_to_string cube.bottom_face.fst.snd)
    (sticker_to_string cube.bottom_face.fst.trd)
    (sticker_to_string cube.bottom_face.snd.fst)
    (sticker_to_string cube.bottom_face.snd.snd)
    (sticker_to_string cube.bottom_face.snd.trd)
    (sticker_to_string cube.bottom_face.trd.fst)
    (sticker_to_string cube.bottom_face.trd.snd)
    (sticker_to_string cube.bottom_face.trd.trd)
