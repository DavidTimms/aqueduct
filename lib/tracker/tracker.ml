open! Core
open! Async
open Cohttp_async
open Async_syntax

type response = Bencode.t

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
    (* return (Bencode.String "TODO") *)
    let+ (http_response, _) = Client.get (Uri.of_string tracker_url) in
    Bencode.Integer (Int64.of_int (Cohttp.Code.code_of_status http_response.status))

let response_to_string response =
  Bencode.pretty_print response
