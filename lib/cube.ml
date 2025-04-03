type sticker = YELLOW | WHITE | BLUE | RED | GREEN | ORANGE
[@@deriving yojson]

type sticker_row = {
  fst : sticker;
  snd : sticker;
  trd : sticker;
}
[@@deriving yojson]

type layer = {
  front : sticker_row;
  right : sticker_row;
  back : sticker_row;
  left : sticker_row;
}
[@@deriving yojson]

type face = {
  fst : sticker_row;
  snd : sticker_row;
  trd : sticker_row;
}
[@@deriving yojson]

type cube = {
  top_face : face;
  top_layer : layer;
  middle_layer : layer;
  bottom_layer : layer;
  bottom_face : face;
}
[@@deriving yojson]

let solved_cube_layer = {
  front = { fst = GREEN; snd = GREEN; trd = GREEN; };
  right = { fst = RED; snd = RED; trd = RED; };
  back = { fst = BLUE; snd = BLUE; trd = BLUE; };
  left = { fst = ORANGE; snd = ORANGE; trd = ORANGE; };
}
let solved_cube =
  {
    top_face = {
      fst = { fst = WHITE; snd = WHITE; trd = WHITE; };
      snd = { fst = WHITE; snd = WHITE; trd = WHITE; };
      trd = { fst = WHITE; snd = WHITE; trd = WHITE; };
    };
    top_layer = solved_cube_layer;
    middle_layer = solved_cube_layer;
    bottom_layer = solved_cube_layer;
    bottom_face = {
      fst = { fst = YELLOW; snd = YELLOW; trd = YELLOW; };
      snd = { fst = YELLOW; snd = YELLOW; trd = YELLOW; };
      trd = { fst = YELLOW; snd = YELLOW; trd = YELLOW; };
    };
  }

let sticker_to_string = function
  | YELLOW -> "Y"
  | WHITE -> "W"
  | BLUE -> "B"
  | RED -> "R"
  | GREEN -> "G"
  | ORANGE -> "O"

let cube_to_string _ = ""
