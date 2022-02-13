open! Core
open Utils

type response = todo

type event =
  | Started
  | Completed
  | Stopped

let send_request
  ~tracker_url
  ~info_hash
  ~peer_id
  ~port
  ~uploaded
  ~downloaded
  ~left
  ~event =
    ignore tracker_url;
    ignore info_hash;
    ignore peer_id;
    ignore port;
    ignore uploaded;
    ignore downloaded;
    ignore left;
    ignore event;
    todo
