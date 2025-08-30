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

let rotate_face_clockwise (face : Cube.face) =
  let face : Cube.face =
    {
      fst = { fst = face.trd.fst; snd = face.snd.fst; trd = face.fst.fst };
      snd = { fst = face.trd.snd; snd = face.snd.snd; trd = face.fst.snd };
      trd = { fst = face.trd.trd; snd = face.snd.trd; trd = face.fst.trd };
    }
  in
  face

let rotate_face_counter_clockwise (face : Cube.face) =
  let face : Cube.face =
    {
      fst = { fst = face.fst.trd; snd = face.snd.trd; trd = face.trd.trd };
      snd = { fst = face.fst.snd; snd = face.snd.snd; trd = face.trd.snd };
      trd = { fst = face.fst.fst; snd = face.snd.fst; trd = face.trd.fst };
    }
  in
  face

let rotate_face face clockwise =
  let rotate =
    if clockwise then rotate_face_clockwise else rotate_face_counter_clockwise
  in
  rotate face

let move_top_layer (layer : Cube.layer) clockwise =
  let new_layer : Cube.layer =
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
  in
  new_layer

let move_bottom_layer (layer : Cube.layer) clockwise =
  let new_layer : Cube.layer =
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
  in
  new_layer

let move_up clockwise (cube : Cube.cube) =
  {
    cube with
    top_face = rotate_face cube.top_face clockwise;
    top_layer = move_top_layer cube.top_layer clockwise;
  }

let move_down clockwise (cube : Cube.cube) =
  {
    cube with
    bottom_face = rotate_face cube.bottom_face clockwise;
    bottom_layer = move_bottom_layer cube.bottom_layer clockwise;
  }

let move_right_clockwise (cube : Cube.cube) =
  let new_cube : Cube.cube =
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
          front =
            { cube.middle_layer.front with trd = cube.bottom_face.snd.trd };
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
          front =
            { cube.bottom_layer.front with trd = cube.bottom_face.trd.trd };
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
  in
  new_cube

let move_right_counter_clockwise (cube : Cube.cube) =
  let new_cube : Cube.cube =
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
  in
  new_cube

let move_left_clockwise (cube : Cube.cube) =
  let new_cube : Cube.cube =
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
  in
  new_cube

let move_left_counter_clockwise (cube : Cube.cube) =
  let new_cube : Cube.cube =
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
          front =
            { cube.middle_layer.front with fst = cube.bottom_face.snd.fst };
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
          front =
            { cube.bottom_layer.front with fst = cube.bottom_face.trd.fst };
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
  in
  new_cube

let move_front_clockwise (cube : Cube.cube) =
  let new_cube : Cube.cube =
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
  in
  new_cube

let move_front_counter_clockwise (cube : Cube.cube) =
  let new_cube : Cube.cube =
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
          right =
            { cube.middle_layer.right with fst = cube.bottom_face.fst.snd };
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
          right =
            { cube.bottom_layer.right with fst = cube.bottom_face.fst.fst };
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
  in
  new_cube

let move_back_clockwise (cube : Cube.cube) =
  let new_cube : Cube.cube =
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
          right =
            { cube.middle_layer.right with trd = cube.bottom_face.trd.snd };
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
          right =
            { cube.bottom_layer.right with trd = cube.bottom_face.trd.fst };
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
  in
  new_cube

let move_back_counter_clockwise (cube : Cube.cube) =
  let new_cube : Cube.cube =
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
  in
  new_cube

let rotate_y_clockwise (cube : Cube.cube) =
  let new_cube : Cube.cube =
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
  in
  new_cube

let rotate_y_counter_clockwise (cube : Cube.cube) =
  let new_cube : Cube.cube =
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
  in
  new_cube

let rotate_x_clockwise (cube : Cube.cube) =
  let new_cube : Cube.cube =
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
  in
  new_cube

let rotate_x_counter_clockwise (cube : Cube.cube) =
  let new_cube : Cube.cube =
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
  in
  new_cube

let make cube move =
  match move with
  | UP_CLOCKWISE -> move_up true cube
  | UP_COUNTER_CLOCKWISE -> move_up false cube
  | UP_TWICE -> cube |> move_up true |> move_up true
  | DOWN_CLOCKWISE -> move_down true cube
  | DOWN_COUNTER_CLOCKWISE -> move_down false cube
  | DOWN_TWICE -> cube |> move_down true |> move_down true
  | RIGHT_CLOCKWISE -> move_right_clockwise cube
  | RIGHT_COUNTER_CLOCKWISE -> move_right_counter_clockwise cube
  | RIGHT_TWICE -> cube |> move_right_clockwise |> move_right_clockwise
  | LEFT_CLOCKWISE -> move_left_clockwise cube
  | LEFT_COUNTER_CLOCKWISE -> move_left_counter_clockwise cube
  | LEFT_TWICE -> cube |> move_left_clockwise |> move_left_clockwise
  | FRONT_CLOCKWISE -> move_front_clockwise cube
  | FRONT_COUNTER_CLOCKWISE -> move_front_counter_clockwise cube
  | FRONT_TWICE -> cube |> move_front_clockwise |> move_front_clockwise
  | BACK_CLOCKWISE -> move_back_clockwise cube
  | BACK_COUNTER_CLOCKWISE -> move_back_counter_clockwise cube
  | BACK_TWICE -> cube |> move_back_clockwise |> move_back_clockwise
  | ROTATE_Y_CLOCKWISE -> rotate_y_clockwise cube
  | ROTATE_Y_COUNTER_CLOCKWISE -> rotate_y_counter_clockwise cube
  | ROTATE_Y_TWICE -> cube |> rotate_y_clockwise |> rotate_y_clockwise
  | ROTATE_X_CLOCKWISE -> rotate_x_clockwise cube
  | ROTATE_X_COUNTER_CLOCKWISE -> rotate_x_counter_clockwise cube
  | ROTATE_X_TWICE -> cube |> rotate_x_clockwise |> rotate_x_clockwise

let to_notation = function
  | UP_CLOCKWISE -> "U"
  | UP_COUNTER_CLOCKWISE -> "U'"
  | UP_TWICE -> "U2"
  | DOWN_CLOCKWISE -> "D"
  | DOWN_COUNTER_CLOCKWISE -> "D'"
  | DOWN_TWICE -> "D2"
  | RIGHT_CLOCKWISE -> "R"
  | RIGHT_COUNTER_CLOCKWISE -> "R'"
  | RIGHT_TWICE -> "R2"
  | LEFT_CLOCKWISE -> "L"
  | LEFT_COUNTER_CLOCKWISE -> "L'"
  | LEFT_TWICE -> "L2"
  | FRONT_CLOCKWISE -> "F"
  | FRONT_COUNTER_CLOCKWISE -> "F'"
  | FRONT_TWICE -> "F2"
  | BACK_CLOCKWISE -> "B"
  | BACK_COUNTER_CLOCKWISE -> "B'"
  | BACK_TWICE -> "B2"
  | ROTATE_Y_CLOCKWISE -> "y"
  | ROTATE_Y_COUNTER_CLOCKWISE -> "y'"
  | ROTATE_Y_TWICE -> "y2"
  | ROTATE_X_CLOCKWISE -> "x"
  | ROTATE_X_COUNTER_CLOCKWISE -> "x'"
  | ROTATE_X_TWICE -> "x2"

let from_notation notation =
  match notation with
  | "U" -> Ok UP_CLOCKWISE
  | "U'" -> Ok UP_COUNTER_CLOCKWISE
  | "U2" -> Ok UP_TWICE
  | "D" -> Ok DOWN_CLOCKWISE
  | "D'" -> Ok DOWN_COUNTER_CLOCKWISE
  | "D2" -> Ok DOWN_TWICE
  | "R" -> Ok RIGHT_CLOCKWISE
  | "R'" -> Ok RIGHT_COUNTER_CLOCKWISE
  | "R2" -> Ok RIGHT_TWICE
  | "L" -> Ok LEFT_CLOCKWISE
  | "L'" -> Ok LEFT_COUNTER_CLOCKWISE
  | "L2" -> Ok LEFT_TWICE
  | "F" -> Ok FRONT_CLOCKWISE
  | "F'" -> Ok FRONT_COUNTER_CLOCKWISE
  | "F2" -> Ok FRONT_TWICE
  | "B" -> Ok BACK_CLOCKWISE
  | "B'" -> Ok BACK_COUNTER_CLOCKWISE
  | "B2" -> Ok BACK_TWICE
  | "y" -> Ok ROTATE_Y_CLOCKWISE
  | "y'" -> Ok ROTATE_Y_COUNTER_CLOCKWISE
  | "y2" -> Ok ROTATE_Y_TWICE
  | "x" -> Ok ROTATE_X_CLOCKWISE
  | "x'" -> Ok ROTATE_X_COUNTER_CLOCKWISE
  | "x2" -> Ok ROTATE_X_TWICE
  | _ -> Error "Invalid move notation"

let execute_scramble scramble =
  let scramble_moves =
    String.split_on_char ' ' scramble
    |> List.map (fun move_notation ->
           Result.get_ok (from_notation move_notation))
  in
  List.fold_left make Cube.solved_cube scramble_moves

let moves_to_string moves =
  List.fold_left
    (fun scramble_string_acc move ->
      scramble_string_acc ^ " " ^ to_notation move)
    "" moves
  |> String.trim
