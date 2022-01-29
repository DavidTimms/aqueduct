open Core

let download ~torrent:torrent_file_path ~destination  =
  ignore destination;
  let metainfo = Metainfo.from_file torrent_file_path in
  print_endline (Int.to_string (List.length metainfo.info.pieces))
