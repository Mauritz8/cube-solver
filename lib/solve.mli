open Cube

type solution = { moves : string list } [@@deriving yojson]
type sub_solution = { cube : cube; moves : string list }

val solve : cube -> (solution, string) result
val solve_cross : cube -> (sub_solution, string) result
val solve_corners_first_layer : cube -> (sub_solution, string) result
val cross_is_solved : cube -> bool
val corners_first_layer_solved : cube -> bool
