open Core
open Async

let (let*) = Deferred.Let_syntax.(>>=)

let download ~torrent:torrent_file_path ~destination  =
  ignore destination;
  let metainfo = Metainfo.from_file torrent_file_path in
  print_endline (Metainfo.tracker_url metainfo);
  let* tracker_response = Metainfo.(
    Tracker.send_request
    ~tracker_url:(tracker_url metainfo)
    ~info_hash:(info_hash metainfo)
    ~peer_id:"aqueduct-test"
    ~port:6881
    ~uploaded:0L
    ~downloaded:0L
    ~left:Int64.(
      (piece_length metainfo) *
      (piece_hashes metainfo |> List.length |> of_int)
    )
    ~event:Started
  ) in
  print_endline (Tracker.response_to_string tracker_response);
  return ()
