type sticker = YELLOW | WHITE | BLUE | RED | GREEN | ORANGE
type direction = UP | DOWN | RIGHT | LEFT | FRONT | BACK
type side = sticker list

type cube = {
  front : side;
  right : side;
  left : side;
  top : side;
  bottom : side;
  back : side;
}

let side_one_sticker sticker = List.init 9 (fun _ -> sticker)

let solved_cube =
  {
    front = side_one_sticker GREEN;
    right = side_one_sticker ORANGE;
    back = side_one_sticker BLUE;
    left = side_one_sticker RED;
    top = side_one_sticker YELLOW;
    bottom = side_one_sticker WHITE;
  }

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
  let front = side_to_string cube.front in
  let right = side_to_string cube.right in
  let back = side_to_string cube.back in
  let left = side_to_string cube.left in
  let top = side_to_string cube.top in
  let bottom = side_to_string cube.bottom in
  String.concat "\n\n" [ top; front; right; back; left; bottom ]

let rotate_side side clockwise =
  let new_side_indexes =
    let indexes = [ 2; 5; 8; 1; 4; 7; 0; 3; 6 ] in
    if clockwise then indexes else List.rev indexes
  in
  List.map (fun i -> List.nth side i) new_side_indexes

let move_up cube clockwise =
  let sticker_map new_stickers_side i sticker =
    if i < 3 then List.nth new_stickers_side i else sticker
  in
  {
    bottom = cube.bottom;
    top = rotate_side cube.top clockwise;
    front =
      List.mapi
        (sticker_map (if clockwise then cube.right else cube.left))
        cube.front;
    right =
      List.mapi
        (sticker_map (if clockwise then cube.back else cube.front))
        cube.right;
    back =
      List.mapi
        (sticker_map (if clockwise then cube.left else cube.right))
        cube.back;
    left =
      List.mapi
        (sticker_map (if clockwise then cube.front else cube.back))
        cube.left;
  }

let move cube direction clockwise =
  match direction with
  | UP -> move_up cube clockwise
  | DOWN -> move_up cube clockwise
  | RIGHT -> move_up cube clockwise
  | LEFT -> move_up cube clockwise
  | FRONT -> move_up cube clockwise
  | BACK -> move_up cube clockwise

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
