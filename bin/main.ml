open Core
open Async

(* TODO refactor this to use Async_command *)
let () =
  let args = Sys.get_argv () in
  let torrent = Array.get args 1 in
  let destination = Array.get args 2 in
  don't_wait_for begin
    Aqueduct.download ~torrent ~destination
    >>| (fun _ -> shutdown 0)
  end

let () = never_returns (Scheduler.go ())
