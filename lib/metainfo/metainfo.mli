type t

type file

type payload =
| Single_file of { length : int64 }
| Directory of { files : file list }

val from_file : string -> t

val tracker_url : t -> string

val suggested_name : t -> string

val piece_length : t -> int64

val piece_hashes : t -> Sha1.t list

val payload : t -> payload
