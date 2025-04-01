open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type sticker = YELLOW | WHITE | BLUE | RED | GREEN | ORANGE
[@@deriving yojson]
type stickers = sticker list [@@deriving yojson]
type cube = {
  front : stickers;
  right : stickers;
  left : stickers;
  top : stickers;
  bottom : stickers;
  back : stickers;
}
[@@deriving yojson]

type face = FRONT | BACK | RIGHT | LEFT | TOP | BOTTOM [@@deriving yojson]

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

let face_to_string = function
  | FRONT -> "FRONT"
  | BACK -> "BACK"
  | RIGHT -> "RIGHT"
  | LEFT -> "LEFT"
  | TOP -> "TOP"
  | BOTTOM -> "BOTTOM"

let sticker_to_string = function
  | YELLOW -> "Y"
  | WHITE -> "W"
  | BLUE -> "B"
  | RED -> "R"
  | GREEN -> "G"
  | ORANGE -> "O"

let stickers_to_string face =
  let f i x =
    if i = 2 || i = 5 then String.cat (sticker_to_string x) "\n"
    else sticker_to_string x
  in
  String.concat "" (List.mapi f face)

let cube_to_string cube =
  let front = stickers_to_string cube.front in
  let right = stickers_to_string cube.right in
  let back = stickers_to_string cube.back in
  let left = stickers_to_string cube.left in
  let top = stickers_to_string cube.top in
  let bottom = stickers_to_string cube.bottom in
  String.concat "\n\n" [ top; front; right; back; left; bottom ]
