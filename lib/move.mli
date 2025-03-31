open Cube

type direction = UP | DOWN | RIGHT | LEFT | FRONT | BACK [@@deriving yojson]
type move = { direction : direction; clockwise : bool } [@@deriving yojson]
type moves = string list [@@deriving yojson]
type scramble = { new_cube : cube; moves : moves } [@@deriving yojson]

val make_move : cube -> move -> cube
val moves_string : move list -> string
val scramble : unit -> scramble
val rotate_cube : cube -> cube
