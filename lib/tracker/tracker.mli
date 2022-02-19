open! Core

type response

type event =
  | Started
  | Completed
  | Stopped

val send_request :
  tracker_url:string ->
  info_hash:Sha1.t ->
  peer_id:string ->
  port:int ->
  uploaded:int64 ->
  downloaded:int64 ->
  left:int64 ->
  event:event ->
  response

val response_to_string : response -> string
