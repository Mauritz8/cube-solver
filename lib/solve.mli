open Cube
open Move

type solution_step = { name : string; moves : move list }

val solve : cube -> (solution_step list, string) result
val solve_cross : cube -> (move list, string) result
val solve_corners_first_layer : cube -> (move list, string) result
val solve_edges_second_layer : cube -> (move list, string) result
