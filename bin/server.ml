open Rubics_cube.Cube

type make_move_req_body = { move : move; cube : cube } [@@deriving yojson]

let () =
  Dream.run @@ Dream.logger
  @@ Dream.router
       [
         Dream.post "/api/move" (fun req ->
             let%lwt body = Dream.body req in
             let data =
               body |> Yojson.Safe.from_string |> make_move_req_body_of_yojson
             in
             let new_cube = make_move data.cube data.move in
             yojson_of_cube new_cube |> Yojson.Safe.to_string |> Dream.json);
         Dream.get "/api/scramble" (fun _ ->
             let scramble = scramble () in
             yojson_of_cube scramble.new_cube
             |> Yojson.Safe.to_string |> Dream.json);
         Dream.post "/api/rotate" (fun req ->
             let%lwt body = Dream.body req in
             let cube =
               body |> Yojson.Safe.from_string |> cube_of_yojson
             in
             let new_cube = rotate_cube cube in
             yojson_of_cube new_cube |> Yojson.Safe.to_string |> Dream.json);
         Dream.get "/" (Dream.from_filesystem "view" "index.html");
         Dream.get "/css/**" (Dream.static "css/");
         Dream.get "/js/**" (Dream.static "js/");
       ]
