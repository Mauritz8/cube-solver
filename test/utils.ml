open Rubik.Cube

let cube_pretty_printer ff cube = Format.fprintf
  ff
  "
         %s %s %s
         %s %s %s
         %s %s %s

  %s %s %s  %s %s %s  %s %s %s  %s %s %s
  %s %s %s  %s %s %s  %s %s %s  %s %s %s
  %s %s %s  %s %s %s  %s %s %s  %s %s %s

         %s %s %s
         %s %s %s
         %s %s %s
  "
  (sticker_to_string cube.top_face.fst.fst)
  (sticker_to_string cube.top_face.fst.snd)
  (sticker_to_string cube.top_face.fst.trd)

  (sticker_to_string cube.top_face.snd.fst)
  (sticker_to_string cube.top_face.snd.snd)
  (sticker_to_string cube.top_face.snd.trd)

  (sticker_to_string cube.top_face.trd.fst)
  (sticker_to_string cube.top_face.trd.snd)
  (sticker_to_string cube.top_face.trd.trd)

  (sticker_to_string cube.top_layer.left.fst)
  (sticker_to_string cube.top_layer.left.snd)
  (sticker_to_string cube.top_layer.left.trd)

  (sticker_to_string cube.top_layer.front.fst)
  (sticker_to_string cube.top_layer.front.snd)
  (sticker_to_string cube.top_layer.front.trd)

  (sticker_to_string cube.top_layer.right.fst)
  (sticker_to_string cube.top_layer.right.snd)
  (sticker_to_string cube.top_layer.right.trd)

  (sticker_to_string cube.top_layer.back.fst)
  (sticker_to_string cube.top_layer.back.snd)
  (sticker_to_string cube.top_layer.back.trd)

  (sticker_to_string cube.middle_layer.left.fst)
  (sticker_to_string cube.middle_layer.left.snd)
  (sticker_to_string cube.middle_layer.left.trd)

  (sticker_to_string cube.middle_layer.front.fst)
  (sticker_to_string cube.middle_layer.front.snd)
  (sticker_to_string cube.middle_layer.front.trd)

  (sticker_to_string cube.middle_layer.right.fst)
  (sticker_to_string cube.middle_layer.right.snd)
  (sticker_to_string cube.middle_layer.right.trd)

  (sticker_to_string cube.middle_layer.back.fst)
  (sticker_to_string cube.middle_layer.back.snd)
  (sticker_to_string cube.middle_layer.back.trd)

  (sticker_to_string cube.bottom_layer.left.fst)
  (sticker_to_string cube.bottom_layer.left.snd)
  (sticker_to_string cube.bottom_layer.left.trd)

  (sticker_to_string cube.bottom_layer.front.fst)
  (sticker_to_string cube.bottom_layer.front.snd)
  (sticker_to_string cube.bottom_layer.front.trd)

  (sticker_to_string cube.bottom_layer.right.fst)
  (sticker_to_string cube.bottom_layer.right.snd)
  (sticker_to_string cube.bottom_layer.right.trd)

  (sticker_to_string cube.bottom_layer.back.fst)
  (sticker_to_string cube.bottom_layer.back.snd)
  (sticker_to_string cube.bottom_layer.back.trd)

  (sticker_to_string cube.bottom_face.fst.fst)
  (sticker_to_string cube.bottom_face.fst.snd)
  (sticker_to_string cube.bottom_face.fst.trd)

  (sticker_to_string cube.bottom_face.snd.fst)
  (sticker_to_string cube.bottom_face.snd.snd)
  (sticker_to_string cube.bottom_face.snd.trd)

  (sticker_to_string cube.bottom_face.trd.fst)
  (sticker_to_string cube.bottom_face.trd.snd)
  (sticker_to_string cube.bottom_face.trd.trd)
