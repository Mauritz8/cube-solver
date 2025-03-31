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

val solved_cube : cube
val face_to_string : face -> string
val cube_to_string : cube -> string
