open Rubics_cube
open Cube

let cube = solved_cube
let cube2 = move cube UP true
let cube3 = move cube2 UP false
let _ = move cube DOWN true
let _ = move cube RIGHT true
let _ = move cube LEFT true
let _ = move cube FRONT true
let _ = move cube BACK true

(*let () = print_endline (cube_to_string cube)*)
(*let () = print_endline (cube_to_string cube2)*)
let () = print_endline (cube_to_string cube3)
