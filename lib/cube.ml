open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type sticker = YELLOW | WHITE | BLUE | RED | GREEN | ORANGE
[@@deriving yojson]
type face = sticker list [@@deriving yojson]
type cube = {
  front : face;
  right : face;
  left : face;
  top : face;
  bottom : face;
  back : face;
}
[@@deriving yojson]

type direction = UP | DOWN | RIGHT | LEFT | FRONT | BACK [@@deriving yojson]
type move = { direction : direction; clockwise : bool } [@@deriving yojson]
type moves = string list [@@deriving yojson]
type scramble = { new_cube : cube; moves : moves } [@@deriving yojson]

let face_one_sticker sticker = List.init 9 (fun _ -> sticker)

let solved_cube =
  {
    front = face_one_sticker GREEN;
    right = face_one_sticker RED;
    back = face_one_sticker BLUE;
    left = face_one_sticker ORANGE;
    top = face_one_sticker WHITE;
    bottom = face_one_sticker YELLOW;
  }

let sticker_to_string = function
  | YELLOW -> "Y"
  | WHITE -> "W"
  | BLUE -> "B"
  | RED -> "R"
  | GREEN -> "G"
  | ORANGE -> "O"

let face_to_string face =
  let f i x =
    if i = 2 || i = 5 then String.cat (sticker_to_string x) "\n"
    else sticker_to_string x
  in
  String.concat "" (List.mapi f face)

let cube_to_string cube =
  let front = face_to_string cube.front in
  let right = face_to_string cube.right in
  let back = face_to_string cube.back in
  let left = face_to_string cube.left in
  let top = face_to_string cube.top in
  let bottom = face_to_string cube.bottom in
  String.concat "\n\n" [ top; front; right; back; left; bottom ]
