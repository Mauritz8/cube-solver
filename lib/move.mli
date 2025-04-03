open Cube

(* TODO: make types abstract, i.e only define the name of the types *)
type layer = TOP | BOTTOM | RIGHT | LEFT | FRONT | BACK [@@deriving yojson]
type move = { layer : layer; clockwise : bool } [@@deriving yojson]
type moves = string list [@@deriving yojson]
type scramble = { new_cube : cube; moves : moves } [@@deriving yojson]

val make_move : cube -> move -> cube
val moves_string : move list -> string
val scramble : unit -> scramble
