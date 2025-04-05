open Cube

type layer = TOP | BOTTOM | RIGHT | LEFT | FRONT | BACK [@@deriving yojson]
type move = { layer : layer; clockwise : bool } [@@deriving yojson]

val make_move : cube -> move -> cube
val move_to_notation : move -> string
