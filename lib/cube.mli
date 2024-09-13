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

val solved_cube : cube
val cube_to_string : cube -> string
val move : cube -> direction -> bool -> cube
