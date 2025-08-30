open Cube

type move =
  | UP_CLOCKWISE
  | UP_COUNTER_CLOCKWISE
  | UP_TWICE
  | DOWN_CLOCKWISE
  | DOWN_COUNTER_CLOCKWISE
  | DOWN_TWICE
  | RIGHT_CLOCKWISE
  | RIGHT_COUNTER_CLOCKWISE
  | RIGHT_TWICE
  | LEFT_CLOCKWISE
  | LEFT_COUNTER_CLOCKWISE
  | LEFT_TWICE
  | FRONT_CLOCKWISE
  | FRONT_COUNTER_CLOCKWISE
  | FRONT_TWICE
  | BACK_CLOCKWISE
  | BACK_COUNTER_CLOCKWISE
  | BACK_TWICE
  | ROTATE_Y_CLOCKWISE
  | ROTATE_Y_COUNTER_CLOCKWISE
  | ROTATE_Y_TWICE
  | ROTATE_X_CLOCKWISE
  | ROTATE_X_COUNTER_CLOCKWISE
  | ROTATE_X_TWICE

val make_move : cube -> move -> cube
val move_to_notation : move -> string
val notation_to_move : string -> (move, string) result
val execute_scramble : string -> cube
val moves_to_string : move list -> string
