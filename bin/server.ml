open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type make_move_req_body = { move : string; cube : Rubik.Cube.cube }
[@@deriving yojson]

type move_list_body = { moves : string list } [@@deriving yojson]

type solution_body_step = { name : string; moves : string list }
[@@deriving yojson]

type solution_body = { steps : solution_body_step list } [@@deriving yojson]

let cors_middleware handler request =
  let%lwt response = handler request in
  Dream.add_header response "Access-Control-Allow-Origin"
    "http://localhost:5173";
  Dream.add_header response "Access-Control-Allow-Methods" "GET, POST, OPTIONS";
  Dream.add_header response "Access-Control-Allow-Headers" "Content-Type";
  if Dream.method_ request = `OPTIONS then Dream.set_status response `OK else ();
  Lwt.return response

let () =
  Dream.initialize_log ~level:`Debug ();

  Dream.run @@ Dream.logger @@ cors_middleware
  @@ Dream.router
       [
         Dream.get "/api/solved_cube" (fun _ ->
             Rubik.Cube.yojson_of_cube Rubik.Cube.solved_cube
             |> Yojson.Safe.to_string |> Dream.json);
         Dream.post "/api/move" (fun req ->
             let%lwt body = Dream.body req in
             let data =
               body |> Yojson.Safe.from_string |> make_move_req_body_of_yojson
             in
             match Rubik.Move.from_notation data.move with
             | Error e ->
                 Dream.error (fun log ->
                     log ~request:req "Invalid move notation: %s" e);
                 Dream.respond e ~status:`Bad_Request
             | Ok move ->
                 let new_cube = Rubik.Move.make data.cube move in
                 Rubik.Cube.yojson_of_cube new_cube
                 |> Yojson.Safe.to_string |> Dream.json);
         Dream.get "/api/scramble" (fun _ ->
             let scramble = Rubik.Scramble.scramble () in
             let scramble_body =
               { moves = List.map Rubik.Move.to_notation scramble }
             in
             yojson_of_move_list_body scramble_body
             |> Yojson.Safe.to_string |> Dream.json);
         Dream.post "/api/solve" (fun req ->
             let%lwt body = Dream.body req in
             let cube =
               Rubik.Cube.cube_of_yojson (Yojson.Safe.from_string body)
             in
             match Rubik.Solve.solve cube with
             | Error e ->
                 Dream.error (fun log ->
                     log ~request:req "Error solving cube: %s" e);
                 Dream.respond e ~status:`Internal_Server_Error
             | Ok solution_steps ->
                 let solution_step_to_body_format =
                  fun (solution_step : Rubik.Solve.solution_step) ->
                   {
                     name = solution_step.name;
                     moves = List.map Rubik.Move.to_notation solution_step.moves;
                   }
                 in
                 let solution_body =
                   {
                     steps =
                       List.map solution_step_to_body_format solution_steps;
                   }
                 in
                 yojson_of_solution_body solution_body
                 |> Yojson.Safe.to_string |> Dream.json);
       ]
