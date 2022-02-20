open! Core
open Async

let connect torrent_state ({ peer_id; ip; port } : Tracker.Peer_info.t) =
  ignore torrent_state;
  ignore peer_id;
  ignore ip;
  ignore port;
  return ()
