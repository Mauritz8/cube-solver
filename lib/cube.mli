type sticker = YELLOW | WHITE | BLUE | RED | GREEN | ORANGE
[@@deriving yojson]
type face = sticker list [@@deriving yojson]
type cube = {
  front : face;
  right : face;
  left : face;
  top : face;
  bottom : face;
  back : face;
}
[@@deriving yojson]

type direction = UP | DOWN | RIGHT | LEFT | FRONT | BACK [@@deriving yojson]
type move = { direction : direction; clockwise : bool } [@@deriving yojson]
type moves = string list [@@deriving yojson]
type scramble = { new_cube : cube; moves : moves } [@@deriving yojson]

val solved_cube : cube
val face_to_string : face -> string
val cube_to_string : cube -> string
val make_move : cube -> move -> cube
val scramble : unit -> scramble
val moves_string : move list -> string
val rotate_cube : cube -> cube
