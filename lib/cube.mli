type sticker = YELLOW | WHITE | BLUE | RED | GREEN | ORANGE [@@deriving yojson]
type direction = UP | DOWN | RIGHT | LEFT | FRONT | BACK
type side = sticker list [@@deriving yojson]

type cube = {
  front : side;
  right : side;
  left : side;
  top : side;
  bottom : side;
  back : side;
} [@@deriving yojson]

val solved_cube : cube
val side_to_string : side -> string
val cube_to_string : cube -> string
val move : cube -> direction -> bool -> cube
