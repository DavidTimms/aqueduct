open Core

let download ~torrent:torrent_file_path ~destination  =
  ignore destination;
  let metainfo = Metainfo.from_file torrent_file_path in
  print_endline (Metainfo.tracker_url metainfo)
