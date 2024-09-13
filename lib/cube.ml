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
    let indexes = [ 6; 3; 0; 7; 4; 1; 8; 5; 2; ] in
    if clockwise then indexes else List.rev indexes
  in
  List.map (fun i -> List.nth side i) new_side_indexes

let replace_at_indexes indexes lst new_lst =
  let f i x = if List.mem i indexes then List.nth new_lst i else x in
  List.mapi f lst

let move_up cube clockwise =
  let replace_func = replace_at_indexes [ 0; 1; 2 ] in
  {
    bottom = cube.bottom;
    top = rotate_side cube.top clockwise;
    front =
      replace_func cube.front (if clockwise then cube.right else cube.left);
    right =
      replace_func cube.right (if clockwise then cube.back else cube.front);
    back = replace_func cube.back (if clockwise then cube.left else cube.right);
    left = replace_func cube.left (if clockwise then cube.front else cube.back);
  }

let move_down cube clockwise =
  let replace_func = replace_at_indexes [ 6; 7; 8 ] in
  {
    top = cube.top;
    bottom = rotate_side cube.bottom clockwise;
    front =
      replace_func cube.front (if clockwise then cube.left else cube.right);
    right =
      replace_func cube.right (if clockwise then cube.front else cube.back);
    back = replace_func cube.back (if clockwise then cube.right else cube.left);
    left = replace_func cube.left (if clockwise then cube.back else cube.front);
  }

let move_right cube clockwise =
  let replace_func = replace_at_indexes [ 2; 5; 8 ] in
  {
    left = cube.left;
    right = rotate_side cube.right clockwise;
    front =
      replace_func cube.front (if clockwise then cube.bottom else cube.top);
    top = replace_func cube.top (if clockwise then cube.front else cube.back);
    back = replace_func cube.back (if clockwise then cube.top else cube.bottom);
    bottom =
      replace_func cube.bottom (if clockwise then cube.back else cube.front);
  }

let move_left cube clockwise =
  let replace_func = replace_at_indexes [ 0; 3; 6 ] in
  {
    right = cube.right;
    left = rotate_side cube.left clockwise;
    front =
      replace_func cube.front (if clockwise then cube.top else cube.bottom);
    top = replace_func cube.top (if clockwise then cube.back else cube.front);
    back = replace_func cube.back (if clockwise then cube.bottom else cube.top);
    bottom =
      replace_func cube.bottom (if clockwise then cube.front else cube.back);
  }

let move_front cube clockwise =
  let replace_func = replace_at_indexes [ 0; 3; 6 ] in
  {
    back = cube.back;
    front = rotate_side cube.front clockwise;
    right =
      replace_func cube.right (if clockwise then cube.top else cube.bottom);
    top = replace_func cube.top (if clockwise then cube.left else cube.right);
    left = replace_func cube.left (if clockwise then cube.bottom else cube.top);
    bottom =
      replace_func cube.bottom (if clockwise then cube.right else cube.left);
  }

let move_back cube clockwise =
  let replace_func = replace_at_indexes [ 0; 1; 2 ] in
  {
    front = cube.front;
    back = rotate_side cube.back clockwise;
    right =
      replace_func cube.right (if clockwise then cube.bottom else cube.top);
    top = replace_func cube.top (if clockwise then cube.right else cube.left);
    left = replace_func cube.left (if clockwise then cube.top else cube.bottom);
    bottom =
      replace_func cube.bottom (if clockwise then cube.left else cube.right);
  }

let move cube direction clockwise =
  let f g = g cube clockwise in
  match direction with
  | UP -> f move_up
  | DOWN -> f move_down
  | RIGHT -> f move_right
  | LEFT -> f move_left
  | FRONT -> f move_front
  | BACK -> f move_back

