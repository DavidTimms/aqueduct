open! Core
open Async

module Response : sig
  type t
  val to_string : t -> string
end

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
  Response.t Deferred.t

