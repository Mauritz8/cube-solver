open Cube
open Move

type moves = string list [@@deriving yojson]
type scramble = { new_cube : cube; moves : moves } [@@deriving yojson]

val moves_string : move list -> string
val scramble : unit -> scramble
