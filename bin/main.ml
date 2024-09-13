type sticker = YELLOW | WHITE | BLUE | RED | GREEN | ORANGE
type direction = UP | DOWN | RIGHT | LEFT | FRONT | BACK

let side_one_sticker sticker = List.init 9 (fun _ -> sticker)

let solved_cube =
  [
    side_one_sticker GREEN;
    side_one_sticker ORANGE;
    side_one_sticker BLUE;
    side_one_sticker RED;
    side_one_sticker YELLOW;
    side_one_sticker WHITE;
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

let rotate_side side clockwise =
  let new_side_indexes =
    let indexes = [2; 5; 8; 1; 4; 7; 0; 3; 6] in
    if clockwise then indexes else List.rev indexes
  in
  List.map (fun i -> List.nth side i) new_side_indexes

let move_up_clockwise cube =
  let side_map i side =
    let sticker_map j sticker =
      let new_stickers_side = List.nth cube (if i = 3 then 0 else i + 1) in
      if j < 3 then List.nth new_stickers_side j else sticker
    in
    if i = 5 then side
    else if i = 4 then rotate_side side true
    else List.mapi sticker_map side
  in
  List.mapi side_map cube

let move_up_counter_clockwise cube =
  let side_map i side =
    let sticker_map j sticker =
      let new_stickers_side = List.nth cube (if i = 0 then 3 else i - 1) in
      if j < 3 then List.nth new_stickers_side j else sticker
    in
    if i = 5 then side
    else if i = 4 then rotate_side side false
    else List.mapi sticker_map side
  in
  List.mapi side_map cube

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
let cube3 = move cube2 UP false
let _ = move cube DOWN true
let _ = move cube RIGHT true
let _ = move cube LEFT true
let _ = move cube FRONT true
let _ = move cube BACK true

(*let () = print_endline (cube_to_string cube)*)
(*let () = print_endline (cube_to_string cube2)*)
let () = print_endline (cube_to_string cube3)
