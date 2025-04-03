open Cube

(* TODO: make types abstract, i.e only define the name of the types *)
type layer = TOP | BOTTOM | RIGHT | LEFT | FRONT | BACK [@@deriving yojson]
type move = { layer : layer; clockwise : bool } [@@deriving yojson]

val make_move : cube -> move -> cube
