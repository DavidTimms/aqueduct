open! Core
open! Async
open Cohttp_async
open Async_syntax

module PeerInfo = struct
  type t = {
    peer_id : Peer_id.t;
    ip : string;
    port : int;
  }

  let from_bencode bencode =
    let open Bencode in
    let open Option_syntax in (
      let* peer_id = dict_get bencode "peer id" >>= as_string >>= Peer_id.from_string in
      let* ip = dict_get bencode "ip" >>= as_string in
      let* port = dict_get bencode "port" >>= as_int >>= Int64.to_int in
      return { peer_id; ip; port }
    ) |> Option.value_exn ~message:"Invalid peer in tracker response"
end

module Response = struct
  type t = {
    interval : int64;
    peers : PeerInfo.t list
  }

  let to_string { interval; peers } =
    "{ interval = " ^ (Int64.to_string interval) ^
    "; peers = " ^ (Int.to_string (List.length peers)) ^
    " }"

  let from_bencode bencode =
    let open Bencode in
    let open Option_syntax in (
      match dict_get bencode "failure reason" >>= as_string with
      | Some failure_reason -> raise (Failure failure_reason)
      | None ->
        let* interval = dict_get bencode "interval" >>= as_int in
        let* peers =
          dict_get bencode "peers"
            >>= as_list
            >>| List.map ~f:PeerInfo.from_bencode
        in
        return { interval; peers }
    ) |> Option.value_exn ~message:"Invalid tracker response"
end

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
    let full_uri = Uri.with_query (Uri.of_string tracker_url) [
      ("info_hash", [Sha1.to_bin info_hash]);
      ("peer_id", [Peer_id.to_string peer_id]);
      ("port", [Int.to_string port]);
      ("uploaded", [Int64.to_string uploaded]);
      ("downloaded", [Int64.to_string downloaded]);
      ("left", [Int64.to_string left]);
      ("event", [event_to_string event]);
    ] in
    (* print_endline (Uri.to_string full_uri); *)
    let* (res, body) = Client.get full_uri in
    let status_code = Cohttp.Code.code_of_status res.status in
    if Cohttp.Code.is_success status_code then
      let* body_string = Body.to_string body in
      return (Bencode.decode (`String body_string) |> Response.from_bencode)
    else
      raise (Failure (
        "Download failed. Tracker returned status " ^ (Int.to_string status_code) ^ "."
      ))
