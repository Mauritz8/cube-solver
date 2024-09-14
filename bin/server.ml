open Rubics_cube.Cube
open Dream_html
open HTML

let sticker_class sticker = 
  match sticker with
  | YELLOW -> "yellow"
  | WHITE -> "white"
  | RED -> "red"
  | BLUE -> "blue"
  | GREEN -> "green"
  | ORANGE -> "orange"
let sticker_div sticker = div [class_ "sticker %s" (sticker_class sticker)] []

let side_div side side_class =
  div [class_ "side"; id side_class] (List.map sticker_div side)

let cube_div cube =
  div [id "cube"] [
    side_div cube.top "top";
    side_div cube.left "left";
    side_div cube.front "front";
    side_div cube.right "right";
    side_div cube.back "back";
    side_div cube.bottom "bottom";
  ]

let page cube =
  html [] [
    head [] [
      title [] "test";
      link [rel "stylesheet"; href "css/style.css"];
    ];
    body [] [
      h1 [] [txt "this is a test"];
      cube_div cube;
      button [type_ "button"; id "move_up_btn"] [txt "U"];
      script [src "js/main.js"] "";
    ];
  ]

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.post "/api/move_up" (fun req ->
      let%lwt body = Dream.body req in
      let cube = body
        |> Yojson.Safe.from_string
        |> cube_of_yojson
      in
      Dream_html.respond (cube_div (move cube UP true))
    );

    Dream.get "/" (fun _ -> Dream_html.respond (page solved_cube));
    Dream.get "/css/**" (Dream.static "css/");
    Dream.get "/js/**" (Dream.static "js/");
  ]
