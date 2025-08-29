open Cube
open Move

(* TODO: make a list of lists. Each list includes the moves solving a step, and the step's name *)
type solution = { moves : move list }
(* type solution = *)
(*   { *)
(*     cross : move list; *)
(*     corners_first_layer : move list; *)
(*     edges_second_layer : move list; *)
(*   } *)

val solve : cube -> (solution, string) result
val solve_cross : cube -> (move list, string) result
val solve_corners_first_layer : cube -> (move list, string) result
val solve_edges_second_layer : cube -> (move list, string) result
