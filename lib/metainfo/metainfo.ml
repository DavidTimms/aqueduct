open Core
open Utils

type file = {
  length : int64;
  directory_path : string list;
  name : string
}

type payload =
  | Single_file of { length : int64 }
  | Directory of { files : file list }

type info = {
  hash: Sha1.t;
  name : string;
  piece_length : int64;
  pieces : Sha1.t list;
  payload : payload;
}

type t = {
  announce: string;
  info : info;
}

let rec parse_pieces concatenated_hashes = 
  if String.is_empty concatenated_hashes then
    [] 
  else
    let hash = String.prefix concatenated_hashes 20 |> Bytes.of_string |> Sha1.of_bin in
    let rest = String.drop_prefix concatenated_hashes 20 in
    (hash :: parse_pieces rest)

let parse_file bencode =
  let length =
    Bencode.dict_get bencode "length"
    |> Option.bind ~f:Bencode.as_int
    |> Option.value_exn
  in
  let path =
    Bencode.dict_get bencode "path"
    |> Option.bind ~f:Bencode.as_list
    |> Option.bind ~f:(traverse_options ~f:Bencode.as_string)
    |> Option.value_exn
  in
  {
    length;
    directory_path = List.drop_last_exn path;
    name = List.last_exn path;
  }

let parse_files =
  List.map ~f:parse_file

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
  let info_hash =
    Bencode.encode_to_string info |> Sha1.string
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
  let single_file_payload =
    Bencode.dict_get info "length"
    |> Option.bind ~f:Bencode.as_int
    |> Option.map ~f:(fun length -> Single_file { length })
  in
  let directory_payload =
    Bencode.dict_get info "files"
    |> Option.bind ~f:Bencode.as_list
    |> Option.map ~f:(fun files -> Directory { files = parse_files files })
  in
  let payload =
    match single_file_payload with
    | Some payload -> payload
    | None -> Option.value_exn directory_payload
  in
  {
    announce;
    info = {
      hash = info_hash;
      name;
      piece_length;
      pieces;
      payload;
    };
  }

let from_file file_path =
  Bencode.decode (`File_path file_path) |> from_bencode

let tracker_url metainfo = metainfo.announce

let info_hash metainfo = metainfo.info.hash

let suggested_name metainfo = metainfo.info.name

let piece_length metainfo = metainfo.info.piece_length

let piece_hashes metainfo = metainfo.info.pieces

let payload metainfo = metainfo.info.payload

let file_length (file : file) = file.length

let file_name (file : file) = file.name

let file_directory_path (file : file) = file.directory_path
