type color = YELLOW | WHITE | BLUE | RED | GREEN | ORANGE
type direction = UP | DOWN | RIGHT | LEFT | FRONT | BACK

let side_one_color color = List.init 9 (fun _ -> color)

let solved_cube =
  [
    side_one_color GREEN;
    side_one_color ORANGE;
    side_one_color BLUE;
    side_one_color RED;
    side_one_color YELLOW;
    side_one_color WHITE;
  ]

let sticker_to_string = function
  | YELLOW -> "Y"
  | WHITE -> "W"
  | BLUE -> "B"
  | RED -> "R"
  | GREEN -> "G"
  | ORANGE -> "O"

let side_to_string side =
  let f i x =
    if i = 2 || i = 5 then String.cat (sticker_to_string x) "\n"
    else sticker_to_string x
  in
  String.concat "" (List.mapi f side)

let cube_to_string cube =
  let side_string n = side_to_string (List.nth cube n) in
  let front = side_string 0 in
  let right = side_string 1 in
  let back = side_string 2 in
  let left = side_string 3 in
  let top = side_string 4 in
  let bottom = side_string 5 in
  String.concat "\n\n" [ top; front; right; back; left; bottom ]

let move_up_clockwise cube =
  let f i x =
    if i = 0 then List.nth cube 3
    else if i < 4 then List.nth cube (i - 1)
    else x
  in
  List.mapi f cube

let move_up_counter_clockwise cube =
  let f i x =
    if i = 3 then List.nth cube 0
    else if i < 3 then List.nth cube (i + 1)
    else x
  in
  List.mapi f cube

let move_clockwise cube direction =
  match direction with
  | UP -> move_up_clockwise cube
  | DOWN -> move_up_clockwise cube
  | RIGHT -> move_up_clockwise cube
  | LEFT -> move_up_clockwise cube
  | FRONT -> move_up_clockwise cube
  | BACK -> move_up_clockwise cube

let move_counter_clockwise cube direction =
  match direction with
  | UP -> move_up_counter_clockwise cube
  | DOWN -> move_up_counter_clockwise cube
  | RIGHT -> move_up_counter_clockwise cube
  | LEFT -> move_up_counter_clockwise cube
  | FRONT -> move_up_counter_clockwise cube
  | BACK -> move_up_counter_clockwise cube

let move cube direction clockwise =
  if clockwise then move_clockwise cube direction
  else move_counter_clockwise cube direction

let cube = solved_cube
let cube2 = move cube UP true
let _ = move cube DOWN true
let _ = move cube RIGHT true
let _ = move cube LEFT true
let _ = move cube FRONT true
let _ = move cube BACK true

(*let () = print_endline (cube_to_string cube)*)
let () = print_endline (cube_to_string cube2)
