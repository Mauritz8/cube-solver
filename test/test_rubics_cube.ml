open Rubics_cube.Cube

(* Scramble: D2 R2 D' L2 U L R2 U' D R' D' R B R' F D F' R B' U F2 B U2 F2 L *)
(* White on top and green on the front *)
(* Generated by https://ruwix.com/puzzle-scramble-generator/?type=rubiks-cube *)
let cube =
  {
    front = [ RED; BLUE; RED; YELLOW; GREEN; ORANGE; WHITE; BLUE; YELLOW ];
    back = [ WHITE; RED; ORANGE; RED; BLUE; ORANGE; WHITE; BLUE; BLUE ];
    right = [ GREEN; ORANGE; BLUE; YELLOW; RED; YELLOW; ORANGE; RED; BLUE ];
    left = [ GREEN; YELLOW; BLUE; WHITE; ORANGE; GREEN; ORANGE; GREEN; GREEN ];
    top = [ WHITE; GREEN; RED; BLUE; WHITE; GREEN; YELLOW; ORANGE; YELLOW ];
    bottom = [ RED; RED; GREEN; WHITE; YELLOW; WHITE; YELLOW; WHITE; ORANGE ];
  }

let move_up_clockwise_test () =
  let expect =
    {
      front =
        [ GREEN; ORANGE; BLUE; YELLOW; GREEN; ORANGE; WHITE; BLUE; YELLOW ];
      back = [ GREEN; YELLOW; BLUE; RED; BLUE; ORANGE; WHITE; BLUE; BLUE ];
      right = [ WHITE; RED; ORANGE; YELLOW; RED; YELLOW; ORANGE; RED; BLUE ];
      left = [ RED; BLUE; RED; WHITE; ORANGE; GREEN; ORANGE; GREEN; GREEN ];
      top = [ YELLOW; BLUE; WHITE; ORANGE; WHITE; GREEN; YELLOW; GREEN; RED ];
      bottom = [ RED; RED; GREEN; WHITE; YELLOW; WHITE; YELLOW; WHITE; ORANGE ];
    }
  in
  let actual = move cube UP true in
  Alcotest.(check string)
    "same front"
    (side_to_string expect.front)
    (side_to_string actual.front);
  Alcotest.(check string)
    "same back"
    (side_to_string expect.back)
    (side_to_string actual.back);
  Alcotest.(check string)
    "same right"
    (side_to_string expect.right)
    (side_to_string actual.right);
  Alcotest.(check string)
    "same left"
    (side_to_string expect.left)
    (side_to_string actual.left);
  Alcotest.(check string)
    "same top"
    (side_to_string expect.top)
    (side_to_string actual.top);
  Alcotest.(check string)
    "same bottom"
    (side_to_string expect.bottom)
    (side_to_string actual.bottom)

let move_down_clockwise_test () =
  let expect =
    {
      front = [ RED; BLUE; RED; YELLOW; GREEN; ORANGE; ORANGE; GREEN; GREEN ];
      back = [ WHITE; RED; ORANGE; RED; BLUE; ORANGE; ORANGE; RED; BLUE ];
      right = [ GREEN; ORANGE; BLUE; YELLOW; RED; YELLOW; WHITE; BLUE; YELLOW ];
      left = [ GREEN; YELLOW; BLUE; WHITE; ORANGE; GREEN; WHITE; BLUE; BLUE ];
      top = [ WHITE; GREEN; RED; BLUE; WHITE; GREEN; YELLOW; ORANGE; YELLOW ];
      bottom = [ YELLOW; WHITE; RED; WHITE; YELLOW; RED; ORANGE; WHITE; GREEN ];
    }
  in
  let actual = move cube DOWN true in
  Alcotest.(check string)
    "same front"
    (side_to_string expect.front)
    (side_to_string actual.front);
  Alcotest.(check string)
    "same back"
    (side_to_string expect.back)
    (side_to_string actual.back);
  Alcotest.(check string)
    "same right"
    (side_to_string expect.right)
    (side_to_string actual.right);
  Alcotest.(check string)
    "same left"
    (side_to_string expect.left)
    (side_to_string actual.left);
  Alcotest.(check string)
    "same top"
    (side_to_string expect.top)
    (side_to_string actual.top);
  Alcotest.(check string)
    "same bottom"
    (side_to_string expect.bottom)
    (side_to_string actual.bottom)

let move_right_clockwise_test () =
  let expect =
    {
      front = [ RED; BLUE; GREEN; YELLOW; GREEN; WHITE; WHITE; BLUE; ORANGE ];
      back = [ YELLOW; RED; ORANGE; GREEN; BLUE; ORANGE; RED; BLUE; BLUE ];
      right = [ ORANGE; YELLOW; GREEN; RED; RED; ORANGE; BLUE; YELLOW; BLUE ];
      left = [ GREEN; YELLOW; BLUE; WHITE; ORANGE; GREEN; ORANGE; GREEN; GREEN ];
      top = [ WHITE; GREEN; RED; BLUE; WHITE; ORANGE; YELLOW; ORANGE; YELLOW ];
      bottom = [ RED; RED; WHITE; WHITE; YELLOW; RED; YELLOW; WHITE; WHITE ];
    }
  in
  let actual = move cube RIGHT true in
  Alcotest.(check string)
    "same front"
    (side_to_string expect.front)
    (side_to_string actual.front);
  Alcotest.(check string)
    "same back"
    (side_to_string expect.back)
    (side_to_string actual.back);
  Alcotest.(check string)
    "same right"
    (side_to_string expect.right)
    (side_to_string actual.right);
  Alcotest.(check string)
    "same left"
    (side_to_string expect.left)
    (side_to_string actual.left);
  Alcotest.(check string)
    "same top"
    (side_to_string expect.top)
    (side_to_string actual.top);
  Alcotest.(check string)
    "same bottom"
    (side_to_string expect.bottom)
    (side_to_string actual.bottom)

let move_left_clockwise_test () =
  let expect =
    {
      front = [ WHITE; BLUE; RED; BLUE; GREEN; ORANGE; YELLOW; BLUE; YELLOW ];
      back = [ WHITE; RED; YELLOW; RED; BLUE; WHITE; WHITE; BLUE; RED ];
      right = [ GREEN; ORANGE; BLUE; YELLOW; RED; YELLOW; ORANGE; RED; BLUE ];
      left = [ ORANGE; WHITE; GREEN; GREEN; ORANGE; YELLOW; GREEN; GREEN; BLUE ];
      top = [ BLUE; GREEN; RED; ORANGE; WHITE; GREEN; ORANGE; ORANGE; YELLOW ];
      bottom = [ RED; RED; GREEN; YELLOW; YELLOW; WHITE; WHITE; WHITE; ORANGE ];
    }
  in
  let actual = move cube LEFT true in
  Alcotest.(check string)
    "same front"
    (side_to_string expect.front)
    (side_to_string actual.front);
  Alcotest.(check string)
    "same back"
    (side_to_string expect.back)
    (side_to_string actual.back);
  Alcotest.(check string)
    "same right"
    (side_to_string expect.right)
    (side_to_string actual.right);
  Alcotest.(check string)
    "same left"
    (side_to_string expect.left)
    (side_to_string actual.left);
  Alcotest.(check string)
    "same top"
    (side_to_string expect.top)
    (side_to_string actual.top);
  Alcotest.(check string)
    "same bottom"
    (side_to_string expect.bottom)
    (side_to_string actual.bottom)

let move_front_clockwise_test () =
  let expect =
    {
      front = [ WHITE; YELLOW; RED; BLUE; GREEN; BLUE; YELLOW; ORANGE; RED ];
      back = [ WHITE; RED; ORANGE; RED; BLUE; ORANGE; WHITE; BLUE; BLUE ];
      right = [ YELLOW; ORANGE; BLUE; ORANGE; RED; YELLOW; YELLOW; RED; BLUE ];
      left = [ GREEN; YELLOW; RED; WHITE; ORANGE; RED; ORANGE; GREEN; GREEN ];
      top = [ WHITE; GREEN; RED; BLUE; WHITE; GREEN; GREEN; GREEN; BLUE ];
      bottom =
        [ ORANGE; YELLOW; GREEN; WHITE; YELLOW; WHITE; YELLOW; WHITE; ORANGE ];
    }
  in
  let actual = move cube FRONT true in
  Alcotest.(check string)
    "same front"
    (side_to_string expect.front)
    (side_to_string actual.front);
  Alcotest.(check string)
    "same back"
    (side_to_string expect.back)
    (side_to_string actual.back);
  Alcotest.(check string)
    "same right"
    (side_to_string expect.right)
    (side_to_string actual.right);
  Alcotest.(check string)
    "same left"
    (side_to_string expect.left)
    (side_to_string actual.left);
  Alcotest.(check string)
    "same top"
    (side_to_string expect.top)
    (side_to_string actual.top);
  Alcotest.(check string)
    "same bottom"
    (side_to_string expect.bottom)
    (side_to_string actual.bottom)

let move_back_clockwise_test () =
  let expect =
    {
      front = [ RED; BLUE; RED; YELLOW; GREEN; ORANGE; WHITE; BLUE; YELLOW ];
      back = [ WHITE; RED; WHITE; BLUE; BLUE; RED; BLUE; ORANGE; ORANGE ];
      right = [ GREEN; ORANGE; ORANGE; YELLOW; RED; WHITE; ORANGE; RED; YELLOW ];
      left = [ RED; YELLOW; BLUE; GREEN; ORANGE; GREEN; WHITE; GREEN; GREEN ];
      top = [ BLUE; YELLOW; BLUE; BLUE; WHITE; GREEN; YELLOW; ORANGE; YELLOW ];
      bottom = [ RED; RED; GREEN; WHITE; YELLOW; WHITE; GREEN; WHITE; ORANGE ];
    }
  in
  let actual = move cube BACK true in
  Alcotest.(check string)
    "same front"
    (side_to_string expect.front)
    (side_to_string actual.front);
  Alcotest.(check string)
    "same back"
    (side_to_string expect.back)
    (side_to_string actual.back);
  Alcotest.(check string)
    "same right"
    (side_to_string expect.right)
    (side_to_string actual.right);
  Alcotest.(check string)
    "same left"
    (side_to_string expect.left)
    (side_to_string actual.left);
  Alcotest.(check string)
    "same top"
    (side_to_string expect.top)
    (side_to_string actual.top);
  Alcotest.(check string)
    "same bottom"
    (side_to_string expect.bottom)
    (side_to_string actual.bottom)

let () =
  let open Alcotest in
  run "Cube"
    [
      ( "moves",
        [
          test_case "Move up clockwise" `Quick move_up_clockwise_test;
          test_case "Move down clockwise" `Quick move_down_clockwise_test;
          test_case "Move right clockwise" `Quick move_right_clockwise_test;
          test_case "Move left clockwise" `Quick move_left_clockwise_test;
          test_case "Move front clockwise" `Quick move_front_clockwise_test;
          test_case "Move back clockwise" `Quick move_back_clockwise_test;
        ] );
    ]
