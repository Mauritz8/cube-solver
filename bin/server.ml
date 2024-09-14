let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (Dream.from_filesystem "view" "index.html");
    Dream.get "/css/**" (Dream.static "css/");
    Dream.get "/js/**" (Dream.static "js/");
  ]
