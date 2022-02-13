open Core

type file = {
  length : int64;
  directory_path : string list;
  name : string
}

(* TODO support single file torrents *)
type info = {
  name : string;
  piece_length : int64;
  pieces : string list;
  files : file list;
}

type t = {
  announce: string;
  info : info;
}

let rec parse_pieces concatenated_hashes = 
  if String.is_empty concatenated_hashes then
    [] 
  else
    let hash = String.prefix concatenated_hashes 20 in
    let rest = String.drop_prefix concatenated_hashes 20 in
    (hash :: parse_pieces rest)

let from_bencode bencode =
  let announce =
    Bencode.dict_get bencode "announce"
    |> Option.bind ~f:Bencode.as_string
    |> Option.value_exn
  in
  let info =
    Bencode.dict_get bencode "info"
    |> Option.value_exn
  in
  let name =
    Bencode.dict_get info "name"
    |> Option.bind ~f:Bencode.as_string
    |> Option.value_exn
  in
  let piece_length =
    Bencode.dict_get info "piece length"
    |> Option.bind ~f:Bencode.as_int
    |> Option.value_exn
  in
  let pieces =
    Bencode.dict_get info "pieces"
    |> Option.bind ~f:Bencode.as_string
    |> Option.map ~f:parse_pieces
    |> Option.value_exn
  in
  let files =
    [] (* TODO *)
  in
  {
    announce;
    info = {
      name;
      piece_length;
      pieces;
      files;
    };
  }

let from_file file_path =
  Bencode.decode (`File_path file_path) |> from_bencode

let tracker_url metainfo = metainfo.announce
