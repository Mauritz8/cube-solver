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

type cube = {
  top_face : face;
  top_layer : layer;
  middle_layer : layer;
  bottom_layer : layer;
  bottom_face : face;
}
[@@deriving yojson]

val solved_cube : cube
val sticker_to_string : sticker -> string
val cube_to_string : cube -> string
