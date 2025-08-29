open Ppx_yojson_conv_lib.Yojson_conv.Primitives
open Rubik.Cube
open Rubik.Move
open Rubik.Scramble
open Rubik.Solve

type make_move_req_body = { move : string; cube : cube } [@@deriving yojson]
type solution_body = { moves : string list } [@@deriving yojson]

let cors_middleware handler request =
  let%lwt response = handler request in
  Dream.add_header response "Access-Control-Allow-Origin"
    "http://localhost:5173";
  Dream.add_header response "Access-Control-Allow-Methods" "GET, POST, OPTIONS";
  Dream.add_header response "Access-Control-Allow-Headers" "Content-Type";
  if Dream.method_ request = `OPTIONS then Dream.set_status response `OK else ();
  Lwt.return response

let () =
  Dream.run @@ Dream.logger @@ cors_middleware
  @@ Dream.router
       [
         Dream.get "/api/solved_cube" (fun _ ->
             yojson_of_cube solved_cube |> Yojson.Safe.to_string |> Dream.json);
         Dream.post "/api/move" (fun req ->
             let%lwt body = Dream.body req in
             let data =
               body |> Yojson.Safe.from_string |> make_move_req_body_of_yojson
             in
             match notation_to_move data.move with
             | Error e ->
                 Dream.error (fun log ->
                     log ~request:req "Invalid move notation: %s" e);
                 Dream.respond e ~status:`Bad_Request
             | Ok move ->
                 let new_cube = make_move data.cube move in
                 yojson_of_cube new_cube |> Yojson.Safe.to_string |> Dream.json);
         Dream.get "/api/scramble" (fun _ ->
             let scramble = scramble () in
             yojson_of_scramble scramble |> Yojson.Safe.to_string |> Dream.json);
         Dream.post "/api/solve" (fun req ->
             let%lwt body = Dream.body req in
             let cube = cube_of_yojson (Yojson.Safe.from_string body) in
             match solve cube with
             | Error e ->
                 Dream.error (fun log ->
                     log ~request:req "Error solving cube: %s" e);
                 Dream.respond e ~status:`Internal_Server_Error
             | Ok solution ->
                 let solution_body = { moves = List.map move_to_notation solution.moves } in
                 yojson_of_solution_body solution_body
                 |> Yojson.Safe.to_string |> Dream.json);
       ]
