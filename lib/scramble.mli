open Cube

type scramble = { new_cube : cube; moves : string list } [@@deriving yojson]
val scramble : unit -> scramble
