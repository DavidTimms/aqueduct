open Async

val download: torrent:string -> destination:string -> unit Deferred.t
