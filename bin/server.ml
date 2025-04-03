open Rubik.Cube
open Rubik.Move
open Rubik.Scramble

type make_move_req_body = { move : move; cube : cube } [@@deriving yojson]

let cors_middleware handler request =
  let%lwt response = handler request in
  Dream.add_header response "Access-Control-Allow-Origin" "*";
  Dream.add_header response "Access-Control-Allow-Methods"
    "GET, POST, PUT, DELETE, OPTIONS";
  Dream.add_header response "Access-Control-Allow-Headers" "Content-Type";
  Dream.set_status response `OK;
  Lwt.return response

let () =
  Dream.run @@ Dream.logger @@ cors_middleware
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
             yojson_of_scramble scramble |> Yojson.Safe.to_string |> Dream.json);
       ]
