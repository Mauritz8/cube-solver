open Cube

(* TODO: support double moves, e.g. U2, R2, etc *)
type move =
  | UP_CLOCKWISE
  | UP_COUNTER_CLOCKWISE
  | DOWN_CLOCKWISE
  | DOWN_COUNTER_CLOCKWISE
  | RIGHT_CLOCKWISE
  | RIGHT_COUNTER_CLOCKWISE
  | LEFT_CLOCKWISE
  | LEFT_COUNTER_CLOCKWISE
  | FRONT_CLOCKWISE
  | FRONT_COUNTER_CLOCKWISE
  | BACK_CLOCKWISE
  | BACK_COUNTER_CLOCKWISE
  | ROTATE_Y_CLOCKWISE
  | ROTATE_Y_COUNTER_CLOCKWISE
  | ROTATE_X_CLOCKWISE
  | ROTATE_X_COUNTER_CLOCKWISE

let rotate_face_clockwise face =
  {
    fst = { fst = face.trd.fst; snd = face.snd.fst; trd = face.fst.fst };
    snd = { fst = face.trd.snd; snd = face.snd.snd; trd = face.fst.snd };
    trd = { fst = face.trd.trd; snd = face.snd.trd; trd = face.fst.trd };
  }

let rotate_face_counter_clockwise face =
  {
    fst = { fst = face.fst.trd; snd = face.snd.trd; trd = face.trd.trd };
    snd = { fst = face.fst.snd; snd = face.snd.snd; trd = face.trd.snd };
    trd = { fst = face.fst.fst; snd = face.snd.fst; trd = face.trd.fst };
  }

let rotate_face face clockwise =
  let rotate =
    if clockwise then rotate_face_clockwise else rotate_face_counter_clockwise
  in
  rotate face

let move_top_layer layer clockwise =
  if clockwise then
    {
      front = layer.right;
      right = layer.back;
      back = layer.left;
      left = layer.front;
    }
  else
    {
      front = layer.left;
      right = layer.front;
      back = layer.right;
      left = layer.back;
    }

let move_bottom_layer layer clockwise =
  if clockwise then
    {
      front = layer.left;
      right = layer.front;
      back = layer.right;
      left = layer.back;
    }
  else
    {
      front = layer.right;
      right = layer.back;
      back = layer.left;
      left = layer.front;
    }

let move_up cube clockwise =
  {
    cube with
    top_face = rotate_face cube.top_face clockwise;
    top_layer = move_top_layer cube.top_layer clockwise;
  }

let move_down cube clockwise =
  {
    cube with
    bottom_face = rotate_face cube.bottom_face clockwise;
    bottom_layer = move_bottom_layer cube.bottom_layer clockwise;
  }

let move_right_clockwise cube =
  {
    top_face =
      {
        fst = { cube.top_face.fst with trd = cube.top_layer.front.trd };
        snd = { cube.top_face.snd with trd = cube.middle_layer.front.trd };
        trd = { cube.top_face.trd with trd = cube.bottom_layer.front.trd };
      };
    top_layer =
      {
        cube.top_layer with
        front = { cube.top_layer.front with trd = cube.bottom_face.fst.trd };
        back = { cube.top_layer.back with fst = cube.top_face.trd.trd };
        right =
          {
            fst = cube.bottom_layer.right.fst;
            snd = cube.middle_layer.right.fst;
            trd = cube.top_layer.right.fst;
          };
      };
    middle_layer =
      {
        cube.middle_layer with
        front = { cube.middle_layer.front with trd = cube.bottom_face.snd.trd };
        back = { cube.middle_layer.back with fst = cube.top_face.snd.trd };
        right =
          {
            cube.middle_layer.right with
            fst = cube.bottom_layer.right.snd;
            trd = cube.top_layer.right.snd;
          };
      };
    bottom_layer =
      {
        cube.bottom_layer with
        front = { cube.bottom_layer.front with trd = cube.bottom_face.trd.trd };
        back = { cube.bottom_layer.back with fst = cube.top_face.fst.trd };
        right =
          {
            fst = cube.bottom_layer.right.trd;
            snd = cube.middle_layer.right.trd;
            trd = cube.top_layer.right.trd;
          };
      };
    bottom_face =
      {
        fst = { cube.bottom_face.fst with trd = cube.bottom_layer.back.fst };
        snd = { cube.bottom_face.snd with trd = cube.middle_layer.back.fst };
        trd = { cube.bottom_face.trd with trd = cube.top_layer.back.fst };
      };
  }

let move_right_counter_clockwise cube =
  {
    top_face =
      {
        fst = { cube.top_face.fst with trd = cube.bottom_layer.back.fst };
        snd = { cube.top_face.snd with trd = cube.middle_layer.back.fst };
        trd = { cube.top_face.trd with trd = cube.top_layer.back.fst };
      };
    top_layer =
      {
        cube.top_layer with
        front = { cube.top_layer.front with trd = cube.top_face.fst.trd };
        back = { cube.top_layer.back with fst = cube.bottom_face.trd.trd };
        right =
          {
            fst = cube.top_layer.right.trd;
            snd = cube.middle_layer.right.trd;
            trd = cube.bottom_layer.right.trd;
          };
      };
    middle_layer =
      {
        cube.middle_layer with
        front = { cube.middle_layer.front with trd = cube.top_face.snd.trd };
        back = { cube.middle_layer.back with fst = cube.bottom_face.snd.trd };
        right =
          {
            fst = cube.top_layer.right.snd;
            snd = cube.middle_layer.right.snd;
            trd = cube.bottom_layer.right.snd;
          };
      };
    bottom_layer =
      {
        cube.bottom_layer with
        front = { cube.bottom_layer.front with trd = cube.top_face.trd.trd };
        back = { cube.bottom_layer.back with fst = cube.bottom_face.fst.trd };
        right =
          {
            fst = cube.top_layer.right.fst;
            snd = cube.middle_layer.right.fst;
            trd = cube.bottom_layer.right.fst;
          };
      };
    bottom_face =
      {
        fst = { cube.bottom_face.fst with trd = cube.top_layer.front.trd };
        snd = { cube.bottom_face.snd with trd = cube.middle_layer.front.trd };
        trd = { cube.bottom_face.trd with trd = cube.bottom_layer.front.trd };
      };
  }

let move_left_clockwise cube =
  {
    top_face =
      {
        fst = { cube.top_face.fst with fst = cube.bottom_layer.back.trd };
        snd = { cube.top_face.snd with fst = cube.middle_layer.back.trd };
        trd = { cube.top_face.trd with fst = cube.top_layer.back.trd };
      };
    top_layer =
      {
        cube.top_layer with
        front = { cube.top_layer.front with fst = cube.top_face.fst.fst };
        back = { cube.top_layer.back with trd = cube.bottom_face.trd.fst };
        left =
          {
            fst = cube.bottom_layer.left.fst;
            snd = cube.middle_layer.left.fst;
            trd = cube.top_layer.left.fst;
          };
      };
    middle_layer =
      {
        cube.middle_layer with
        front = { cube.middle_layer.front with fst = cube.top_face.snd.fst };
        back = { cube.middle_layer.back with trd = cube.bottom_face.snd.fst };
        left =
          {
            fst = cube.bottom_layer.left.snd;
            snd = cube.middle_layer.left.snd;
            trd = cube.top_layer.left.snd;
          };
      };
    bottom_layer =
      {
        cube.bottom_layer with
        front = { cube.bottom_layer.front with fst = cube.top_face.trd.fst };
        back = { cube.bottom_layer.back with trd = cube.bottom_face.fst.fst };
        left =
          {
            fst = cube.bottom_layer.left.trd;
            snd = cube.middle_layer.left.trd;
            trd = cube.top_layer.left.trd;
          };
      };
    bottom_face =
      {
        fst = { cube.bottom_face.fst with fst = cube.top_layer.front.fst };
        snd = { cube.bottom_face.snd with fst = cube.middle_layer.front.fst };
        trd = { cube.bottom_face.trd with fst = cube.bottom_layer.front.fst };
      };
  }

let move_left_counter_clockwise cube =
  {
    top_face =
      {
        fst = { cube.top_face.fst with fst = cube.top_layer.front.fst };
        snd = { cube.top_face.snd with fst = cube.middle_layer.front.fst };
        trd = { cube.top_face.trd with fst = cube.bottom_layer.front.fst };
      };
    top_layer =
      {
        cube.top_layer with
        front = { cube.top_layer.front with fst = cube.bottom_face.fst.fst };
        back = { cube.top_layer.back with trd = cube.top_face.trd.fst };
        left =
          {
            fst = cube.top_layer.left.trd;
            snd = cube.middle_layer.left.trd;
            trd = cube.bottom_layer.left.trd;
          };
      };
    middle_layer =
      {
        cube.middle_layer with
        front = { cube.middle_layer.front with fst = cube.bottom_face.snd.fst };
        back = { cube.middle_layer.back with trd = cube.top_face.snd.fst };
        left =
          {
            fst = cube.top_layer.left.snd;
            snd = cube.middle_layer.left.snd;
            trd = cube.bottom_layer.left.snd;
          };
      };
    bottom_layer =
      {
        cube.bottom_layer with
        front = { cube.bottom_layer.front with fst = cube.bottom_face.trd.fst };
        back = { cube.bottom_layer.back with trd = cube.top_face.fst.fst };
        left =
          {
            fst = cube.top_layer.left.fst;
            snd = cube.middle_layer.left.fst;
            trd = cube.bottom_layer.left.fst;
          };
      };
    bottom_face =
      {
        fst = { cube.bottom_face.fst with fst = cube.bottom_layer.back.trd };
        snd = { cube.bottom_face.snd with fst = cube.middle_layer.back.trd };
        trd = { cube.bottom_face.trd with fst = cube.top_layer.back.trd };
      };
  }

let move_front_clockwise cube =
  {
    top_face =
      {
        cube.top_face with
        trd =
          {
            fst = cube.bottom_layer.left.trd;
            snd = cube.middle_layer.left.trd;
            trd = cube.top_layer.left.trd;
          };
      };
    top_layer =
      {
        cube.top_layer with
        left = { cube.top_layer.left with trd = cube.bottom_face.fst.fst };
        right = { cube.top_layer.right with fst = cube.top_face.trd.fst };
        front =
          {
            fst = cube.bottom_layer.front.fst;
            snd = cube.middle_layer.front.fst;
            trd = cube.top_layer.front.fst;
          };
      };
    middle_layer =
      {
        cube.middle_layer with
        left = { cube.middle_layer.left with trd = cube.bottom_face.fst.snd };
        right = { cube.middle_layer.right with fst = cube.top_face.trd.snd };
        front =
          {
            fst = cube.bottom_layer.front.snd;
            snd = cube.middle_layer.front.snd;
            trd = cube.top_layer.front.snd;
          };
      };
    bottom_layer =
      {
        cube.bottom_layer with
        left = { cube.bottom_layer.left with trd = cube.bottom_face.fst.trd };
        right = { cube.bottom_layer.right with fst = cube.top_face.trd.trd };
        front =
          {
            fst = cube.bottom_layer.front.trd;
            snd = cube.middle_layer.front.trd;
            trd = cube.top_layer.front.trd;
          };
      };
    bottom_face =
      {
        cube.bottom_face with
        fst =
          {
            fst = cube.bottom_layer.right.fst;
            snd = cube.middle_layer.right.fst;
            trd = cube.top_layer.right.fst;
          };
      };
  }

let move_front_counter_clockwise cube =
  {
    top_face =
      {
        cube.top_face with
        trd =
          {
            fst = cube.top_layer.right.fst;
            snd = cube.middle_layer.right.fst;
            trd = cube.bottom_layer.right.fst;
          };
      };
    top_layer =
      {
        cube.top_layer with
        left = { cube.top_layer.left with trd = cube.top_face.trd.trd };
        right = { cube.top_layer.right with fst = cube.bottom_face.fst.trd };
        front =
          {
            fst = cube.top_layer.front.trd;
            snd = cube.middle_layer.front.trd;
            trd = cube.bottom_layer.front.trd;
          };
      };
    middle_layer =
      {
        cube.middle_layer with
        left = { cube.middle_layer.left with trd = cube.top_face.trd.snd };
        right = { cube.middle_layer.right with fst = cube.bottom_face.fst.snd };
        front =
          {
            fst = cube.top_layer.front.snd;
            snd = cube.middle_layer.front.snd;
            trd = cube.bottom_layer.front.snd;
          };
      };
    bottom_layer =
      {
        cube.bottom_layer with
        left = { cube.bottom_layer.left with trd = cube.top_face.trd.fst };
        right = { cube.bottom_layer.right with fst = cube.bottom_face.fst.fst };
        front =
          {
            fst = cube.top_layer.front.fst;
            snd = cube.middle_layer.front.fst;
            trd = cube.bottom_layer.front.fst;
          };
      };
    bottom_face =
      {
        cube.bottom_face with
        fst =
          {
            fst = cube.top_layer.left.trd;
            snd = cube.middle_layer.left.trd;
            trd = cube.bottom_layer.left.trd;
          };
      };
  }

let move_back_clockwise cube =
  {
    top_face =
      {
        cube.top_face with
        fst =
          {
            fst = cube.top_layer.right.trd;
            snd = cube.middle_layer.right.trd;
            trd = cube.bottom_layer.right.trd;
          };
      };
    top_layer =
      {
        cube.top_layer with
        left = { cube.top_layer.left with fst = cube.top_face.fst.trd };
        right = { cube.top_layer.right with trd = cube.bottom_face.trd.trd };
        back =
          {
            fst = cube.bottom_layer.back.fst;
            snd = cube.middle_layer.back.fst;
            trd = cube.top_layer.back.fst;
          };
      };
    middle_layer =
      {
        cube.middle_layer with
        left = { cube.middle_layer.left with fst = cube.top_face.fst.snd };
        right = { cube.middle_layer.right with trd = cube.bottom_face.trd.snd };
        back =
          {
            fst = cube.bottom_layer.back.snd;
            snd = cube.middle_layer.back.snd;
            trd = cube.top_layer.back.snd;
          };
      };
    bottom_layer =
      {
        cube.bottom_layer with
        left = { cube.bottom_layer.left with fst = cube.top_face.fst.fst };
        right = { cube.bottom_layer.right with trd = cube.bottom_face.trd.fst };
        back =
          {
            fst = cube.bottom_layer.back.trd;
            snd = cube.middle_layer.back.trd;
            trd = cube.top_layer.back.trd;
          };
      };
    bottom_face =
      {
        cube.bottom_face with
        trd =
          {
            fst = cube.top_layer.left.fst;
            snd = cube.middle_layer.left.fst;
            trd = cube.bottom_layer.left.fst;
          };
      };
  }

let move_back_counter_clockwise cube =
  {
    top_face =
      {
        cube.top_face with
        fst =
          {
            fst = cube.bottom_layer.left.fst;
            snd = cube.middle_layer.left.fst;
            trd = cube.top_layer.left.fst;
          };
      };
    top_layer =
      {
        cube.top_layer with
        left = { cube.top_layer.left with fst = cube.bottom_face.trd.fst };
        right = { cube.top_layer.right with trd = cube.top_face.fst.fst };
        back =
          {
            fst = cube.top_layer.back.trd;
            snd = cube.middle_layer.back.trd;
            trd = cube.bottom_layer.back.trd;
          };
      };
    middle_layer =
      {
        cube.middle_layer with
        left = { cube.middle_layer.left with fst = cube.bottom_face.trd.snd };
        right = { cube.middle_layer.right with trd = cube.top_face.fst.snd };
        back =
          {
            fst = cube.top_layer.back.snd;
            snd = cube.middle_layer.back.snd;
            trd = cube.bottom_layer.back.snd;
          };
      };
    bottom_layer =
      {
        cube.bottom_layer with
        left = { cube.bottom_layer.left with fst = cube.bottom_face.trd.trd };
        right = { cube.bottom_layer.right with trd = cube.top_face.fst.trd };
        back =
          {
            fst = cube.top_layer.back.fst;
            snd = cube.middle_layer.back.fst;
            trd = cube.bottom_layer.back.fst;
          };
      };
    bottom_face =
      {
        cube.bottom_face with
        trd =
          {
            fst = cube.bottom_layer.right.trd;
            snd = cube.middle_layer.right.trd;
            trd = cube.top_layer.right.trd;
          };
      };
  }

let rotate_y_clockwise cube =
  {
    top_face = rotate_face cube.top_face true;
    bottom_face = rotate_face cube.bottom_face false;
    top_layer =
      {
        front = cube.top_layer.right;
        left = cube.top_layer.front;
        back = cube.top_layer.left;
        right = cube.top_layer.back;
      };
    middle_layer =
      {
        front = cube.middle_layer.right;
        left = cube.middle_layer.front;
        back = cube.middle_layer.left;
        right = cube.middle_layer.back;
      };
    bottom_layer =
      {
        front = cube.bottom_layer.right;
        left = cube.bottom_layer.front;
        back = cube.bottom_layer.left;
        right = cube.bottom_layer.back;
      };
  }

let rotate_y_counter_clockwise cube =
  {
    top_face = rotate_face cube.top_face false;
    bottom_face = rotate_face cube.bottom_face true;
    top_layer =
      {
        front = cube.top_layer.left;
        left = cube.top_layer.back;
        back = cube.top_layer.right;
        right = cube.top_layer.front;
      };
    middle_layer =
      {
        front = cube.middle_layer.left;
        left = cube.middle_layer.back;
        back = cube.middle_layer.right;
        right = cube.middle_layer.front;
      };
    bottom_layer =
      {
        front = cube.bottom_layer.left;
        left = cube.bottom_layer.back;
        back = cube.bottom_layer.right;
        right = cube.bottom_layer.front;
      };
  }

let rotate_x_clockwise cube =
  {
    top_face =
      {
        fst = cube.top_layer.front;
        snd = cube.middle_layer.front;
        trd = cube.bottom_layer.front;
      };
    bottom_face =
      {
        fst =
          {
            fst = cube.bottom_layer.back.trd;
            snd = cube.bottom_layer.back.snd;
            trd = cube.bottom_layer.back.fst;
          };
        snd =
          {
            fst = cube.middle_layer.back.trd;
            snd = cube.middle_layer.back.snd;
            trd = cube.middle_layer.back.fst;
          };
        trd =
          {
            fst = cube.top_layer.back.trd;
            snd = cube.top_layer.back.snd;
            trd = cube.top_layer.back.fst;
          };
      };
    top_layer =
      {
        front = cube.bottom_face.fst;
        back =
          {
            fst = cube.top_face.trd.trd;
            snd = cube.top_face.trd.snd;
            trd = cube.top_face.trd.fst;
          };
        left =
          {
            fst = cube.top_layer.left.trd;
            snd = cube.middle_layer.left.trd;
            trd = cube.bottom_layer.left.trd;
          };
        right =
          {
            fst = cube.bottom_layer.right.fst;
            snd = cube.middle_layer.right.fst;
            trd = cube.top_layer.right.fst;
          };
      };
    middle_layer =
      {
        front = cube.bottom_face.snd;
        back =
          {
            fst = cube.top_face.snd.trd;
            snd = cube.top_face.snd.snd;
            trd = cube.top_face.snd.fst;
          };
        left =
          {
            fst = cube.top_layer.left.snd;
            snd = cube.middle_layer.left.snd;
            trd = cube.bottom_layer.left.snd;
          };
        right =
          {
            fst = cube.bottom_layer.right.snd;
            snd = cube.middle_layer.right.snd;
            trd = cube.top_layer.right.snd;
          };
      };
    bottom_layer =
      {
        front = cube.bottom_face.trd;
        back =
          {
            fst = cube.top_face.fst.trd;
            snd = cube.top_face.fst.snd;
            trd = cube.top_face.fst.fst;
          };
        left =
          {
            fst = cube.top_layer.left.fst;
            snd = cube.middle_layer.left.fst;
            trd = cube.bottom_layer.left.fst;
          };
        right =
          {
            fst = cube.bottom_layer.right.trd;
            snd = cube.middle_layer.right.trd;
            trd = cube.top_layer.right.trd;
          };
      };
  }

let rotate_x_counter_clockwise cube =
  {
    bottom_face =
      {
        fst = cube.top_layer.front;
        snd = cube.middle_layer.front;
        trd = cube.bottom_layer.front;
      };
    top_face =
      {
        fst =
          {
            fst = cube.bottom_layer.back.trd;
            snd = cube.bottom_layer.back.snd;
            trd = cube.bottom_layer.back.fst;
          };
        snd =
          {
            fst = cube.middle_layer.back.trd;
            snd = cube.middle_layer.back.snd;
            trd = cube.middle_layer.back.fst;
          };
        trd =
          {
            fst = cube.top_layer.back.trd;
            snd = cube.top_layer.back.snd;
            trd = cube.top_layer.back.fst;
          };
      };
    top_layer =
      {
        front = cube.top_face.fst;
        back =
          {
            fst = cube.bottom_face.trd.trd;
            snd = cube.bottom_face.trd.snd;
            trd = cube.bottom_face.trd.fst;
          };
        left =
          {
            fst = cube.bottom_layer.left.fst;
            snd = cube.middle_layer.left.fst;
            trd = cube.top_layer.left.fst;
          };
        right =
          {
            fst = cube.top_layer.right.trd;
            snd = cube.middle_layer.right.trd;
            trd = cube.bottom_layer.right.trd;
          };
      };
    middle_layer =
      {
        front = cube.top_face.snd;
        back =
          {
            fst = cube.bottom_face.snd.trd;
            snd = cube.bottom_face.snd.snd;
            trd = cube.bottom_face.snd.fst;
          };
        left =
          {
            fst = cube.bottom_layer.left.snd;
            snd = cube.middle_layer.left.snd;
            trd = cube.top_layer.left.snd;
          };
        right =
          {
            fst = cube.top_layer.right.snd;
            snd = cube.middle_layer.right.snd;
            trd = cube.bottom_layer.right.snd;
          };
      };
    bottom_layer =
      {
        front = cube.top_face.trd;
        back =
          {
            fst = cube.bottom_face.fst.trd;
            snd = cube.bottom_face.fst.snd;
            trd = cube.bottom_face.fst.fst;
          };
        left =
          {
            fst = cube.bottom_layer.left.trd;
            snd = cube.middle_layer.left.trd;
            trd = cube.top_layer.left.trd;
          };
        right =
          {
            fst = cube.top_layer.right.fst;
            snd = cube.middle_layer.right.fst;
            trd = cube.bottom_layer.right.fst;
          };
      };
  }

let make_move cube move =
  match move with
  | UP_CLOCKWISE -> move_up cube true
  | UP_COUNTER_CLOCKWISE -> move_up cube false
  | DOWN_CLOCKWISE -> move_down cube true
  | DOWN_COUNTER_CLOCKWISE -> move_down cube false
  | RIGHT_CLOCKWISE -> move_right_clockwise cube
  | RIGHT_COUNTER_CLOCKWISE -> move_right_counter_clockwise cube
  | LEFT_CLOCKWISE -> move_left_clockwise cube
  | LEFT_COUNTER_CLOCKWISE -> move_left_counter_clockwise cube
  | FRONT_CLOCKWISE -> move_front_clockwise cube
  | FRONT_COUNTER_CLOCKWISE -> move_front_counter_clockwise cube
  | BACK_CLOCKWISE -> move_back_clockwise cube
  | BACK_COUNTER_CLOCKWISE -> move_back_counter_clockwise cube
  | ROTATE_Y_CLOCKWISE -> rotate_y_clockwise cube
  | ROTATE_Y_COUNTER_CLOCKWISE -> rotate_y_counter_clockwise cube
  | ROTATE_X_CLOCKWISE -> rotate_x_clockwise cube
  | ROTATE_X_COUNTER_CLOCKWISE -> rotate_x_counter_clockwise cube

let move_to_notation = function
  | UP_CLOCKWISE -> "U"
  | UP_COUNTER_CLOCKWISE -> "U'"
  | DOWN_CLOCKWISE -> "D"
  | DOWN_COUNTER_CLOCKWISE -> "D'"
  | RIGHT_CLOCKWISE -> "R"
  | RIGHT_COUNTER_CLOCKWISE -> "R'"
  | LEFT_CLOCKWISE -> "L"
  | LEFT_COUNTER_CLOCKWISE -> "L'"
  | FRONT_CLOCKWISE -> "F"
  | FRONT_COUNTER_CLOCKWISE -> "F'"
  | BACK_CLOCKWISE -> "B"
  | BACK_COUNTER_CLOCKWISE -> "B'"
  | ROTATE_Y_CLOCKWISE -> "y"
  | ROTATE_Y_COUNTER_CLOCKWISE -> "y'"
  | ROTATE_X_CLOCKWISE -> "x"
  | ROTATE_X_COUNTER_CLOCKWISE -> "x'"

let notation_to_move notation =
  match notation with
  | "U" -> Ok UP_CLOCKWISE
  | "U'" -> Ok UP_COUNTER_CLOCKWISE
  | "D" -> Ok DOWN_CLOCKWISE
  | "D'" -> Ok DOWN_COUNTER_CLOCKWISE
  | "R" -> Ok RIGHT_CLOCKWISE
  | "R'" -> Ok RIGHT_COUNTER_CLOCKWISE
  | "L" -> Ok LEFT_CLOCKWISE
  | "L'" -> Ok LEFT_COUNTER_CLOCKWISE
  | "F" -> Ok FRONT_CLOCKWISE
  | "F'" -> Ok FRONT_COUNTER_CLOCKWISE
  | "B" -> Ok BACK_CLOCKWISE
  | "B'" -> Ok BACK_COUNTER_CLOCKWISE
  | "y" -> Ok ROTATE_Y_CLOCKWISE
  | "y'" -> Ok ROTATE_X_COUNTER_CLOCKWISE
  | "x" -> Ok ROTATE_X_CLOCKWISE
  | "x'" -> Ok ROTATE_X_COUNTER_CLOCKWISE
  | _ -> Error "Invalid move notation"

let execute_scramble scramble =
  let scramble_moves =
    String.split_on_char ' ' scramble
    |> List.map (fun move_notation ->
           Result.get_ok (notation_to_move move_notation))
  in
  List.fold_left make_move solved_cube scramble_moves
