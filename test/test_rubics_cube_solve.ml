open Rubics_cube.Cube
open Rubics_cube.Solve

let cube =
  {
    front = [ RED; BLUE; RED; YELLOW; GREEN; ORANGE; WHITE; BLUE; YELLOW ];
    back = [ WHITE; RED; ORANGE; RED; BLUE; ORANGE; WHITE; BLUE; BLUE ];
    right = [ GREEN; ORANGE; BLUE; YELLOW; RED; YELLOW; ORANGE; RED; BLUE ];
    left = [ GREEN; YELLOW; BLUE; WHITE; ORANGE; GREEN; ORANGE; GREEN; GREEN ];
    top = [ WHITE; GREEN; RED; BLUE; WHITE; GREEN; YELLOW; ORANGE; YELLOW ];
    bottom = [ RED; RED; GREEN; WHITE; YELLOW; WHITE; YELLOW; WHITE; ORANGE ];
  }

let solve_cross_test () =
  let color = WHITE in
  let cross_stickers_expected =
    List.map sticker_to_string [color; color; color; color; color] in

  let actual = solve_cross cube in
  let cross_sticker_indexes = [1; 3; 4; 5; 7] in
  let sticker_is_cross i _ = List.mem i cross_sticker_indexes in
  let cross_stickers = List.filteri sticker_is_cross actual.top in
  let cross_stickers_str = List.map sticker_to_string cross_stickers in
  Alcotest.(check (list string))
    "cross solved"
    (cross_stickers_expected)
    (cross_stickers_str)

let () =
  let open Alcotest in
  run "Solve"
    [
      ( "cross",
        [
          test_case "1" `Quick solve_cross_test;
        ] );
    ]
