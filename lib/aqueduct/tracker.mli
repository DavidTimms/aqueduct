open! Core
open Async

type response

type event =
  | Started
  | Completed
  | Stopped
  | Empty

val send_request :
  tracker_url:string ->
  info_hash:Sha1.t ->
  peer_id:Peer_id.t ->
  port:int ->
  uploaded:int64 ->
  downloaded:int64 ->
  left:int64 ->
  event:event ->
  response Deferred.t

val response_to_string : response -> string
