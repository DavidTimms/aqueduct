type t

type file

type payload =
| Single_file of { length : int64 }
| Directory of { files : file list }

val from_file : string -> t

val tracker_url : t -> string

val info_hash: t -> Sha1.t

val suggested_name : t -> string

val piece_length : t -> int64

val piece_hashes : t -> Sha1.t list

val payload : t -> payload

val file_length : file -> int64

val file_name : file -> string

val file_directory_path : file -> string list
