type solution_step = { name : string; moves : Move.move list }

val solve : Cube.cube -> (solution_step list, string) result
val solve_cross : Cube.cube -> (Move.move list, string) result
val solve_corners_first_layer : Cube.cube -> (Move.move list, string) result
val solve_edges_second_layer : Cube.cube -> (Move.move list, string) result
