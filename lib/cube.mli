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
val to_string : cube -> string
val cross_top_face_is_solved : cube -> bool
val cross_bottom_face_is_solved : cube -> bool
val corners_top_layer_are_solved : cube -> bool
val corners_bottom_layer_are_solved : cube -> bool
val edges_second_layer_are_solved : cube -> bool
