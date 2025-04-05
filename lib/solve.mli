open Cube

type solution = { cube : cube; moves : string list } [@@deriving yojson]

val solve_cross : cube -> (solution, string) result
