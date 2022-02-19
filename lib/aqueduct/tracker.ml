open! Core
open! Async
open Cohttp_async
open Async_syntax

type response = string

type event =
  | Started
  | Completed
  | Stopped
  | Empty

let event_to_string event =
  match event with
  | Started -> "started"
  | Completed -> "completed"
  | Stopped -> "stopped"
  | Empty -> "empty"

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
    let full_uri = Uri.with_query (Uri.of_string tracker_url) [
      ("info_hash", [Sha1.to_bin info_hash]);
      ("peer_id", [Peer_id.to_string peer_id]);
      ("port", [Int.to_string port]);
      ("uploaded", [Int64.to_string uploaded]);
      ("downloaded", [Int64.to_string downloaded]);
      ("left", [Int64.to_string left]);
      ("event", [event_to_string event]);
    ] in
    print_endline (Uri.to_string full_uri);
    let* (res, body) = Client.get full_uri in
    let* body_string = Body.to_string body in
    return ((Cohttp.Code.string_of_status res.status) ^ "\n" ^ body_string)

let response_to_string response =
  response
