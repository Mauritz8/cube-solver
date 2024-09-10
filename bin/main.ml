type sticker = YELLOW | WHITE | BLUE | RED | GREEN | ORANGE
type corner = sticker * sticker * sticker
type edge = sticker * sticker
type top_or_bottom_layer = { corners : corner list; edges : edge list }
type middle_layer = { corners : corner list; center_stickers : sticker list }

type rubics_cube = {
  top_layer : top_or_bottom_layer;
  middle_layer : middle_layer;
  bottom_layer : top_or_bottom_layer;
}

let () = print_endline "Hello, World!"
