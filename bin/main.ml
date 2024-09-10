type color = YELLOW | WHITE | BLUE | RED | GREEN | ORANGE

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

let sticker_to_string sticker =
  match sticker with
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

let cube_to_string cube = side_to_string (List.nth cube 0)

let () =
  let cube_string = cube_to_string solved_cube in
  print_endline cube_string
