type sticker = YELLOW | WHITE | BLUE | RED | GREEN | ORANGE
[@@deriving yojson]

type direction = UP | DOWN | RIGHT | LEFT | FRONT | BACK [@@deriving yojson]
type side = sticker list [@@deriving yojson]

type cube = {
  front : side;
  right : side;
  left : side;
  top : side;
  bottom : side;
  back : side;
}
[@@deriving yojson]

type move = { direction : direction; clockwise : bool } [@@deriving yojson]
type scramble = { new_cube : cube; moves : move list }

val solved_cube : cube
val side_to_string : side -> string
val cube_to_string : cube -> string
val make_move : cube -> move -> cube
val scramble : unit -> scramble
val moves_string : move list -> string
