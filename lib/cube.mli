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

val solved_cube : cube
val face_to_string : face -> string
val sticker_to_string : sticker -> string
val stickers_to_string : stickers -> string
val cube_to_string : cube -> string
