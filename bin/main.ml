open Core

let () =
  let args = Sys.get_argv () in
  let torrent = Array.get args 1 in
  let destination = Array.get args 2 in
  Aqueduct.download ~torrent ~destination
