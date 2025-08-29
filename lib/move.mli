open Cube

type move_type = UP | DOWN | RIGHT | LEFT | FRONT | BACK | ROTATE_Y | ROTATE_X
[@@deriving yojson]

type move = { move_type : move_type; clockwise : bool } [@@deriving yojson]

val make_move : cube -> move -> cube
val move_to_notation : move -> string
val notation_to_move : string -> (move, string) result
