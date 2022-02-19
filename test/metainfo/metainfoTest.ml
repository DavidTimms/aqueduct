open! Core

let cosmos_laundromat =
  Metainfo.from_file "../../samples/cosmos-laundromat.torrent"

let ubuntu =
  Metainfo.from_file "../../samples/ubuntu.iso.torrent"

let%test_unit "It should parse the tracker URL from the 'announce' field" =
  let tracker_url = Metainfo.tracker_url cosmos_laundromat in
  assert (String.equal tracker_url "udp://tracker.leechers-paradise.org:6969")

let%test_unit "It should generate the SHA1 hash of the 'info' dictionary" =
  let info_hash = Metainfo.info_hash cosmos_laundromat in
  assert (String.equal (Sha1.to_hex info_hash) "c9e15763f722f23e98a29decdfae341b98d53056")

let%test_unit "It should parse the suggested name from the 'info.name' field" =
  let suggested_name = Metainfo.suggested_name cosmos_laundromat in
  assert (String.equal suggested_name "Cosmos Laundromat")

let%test_unit "It should parse the piece length from the 'info.piece length' field" =
  let piece_length = Metainfo.piece_length cosmos_laundromat in
  assert (Int64.equal piece_length 262144L)

(* This test compares the SHA1 hashes as hex strings, because the Sha1.equal function
   doesn't seem to work correctly. *)
let%test_unit "It should parse the piece hashes from the 'info.pieces' field" =
  let piece_hashes = Metainfo.piece_hashes cosmos_laundromat |> List.map ~f:Sha1.to_hex in
  let expected = TestData.cosmos_laundromat_piece_hashes |> List.map ~f:Sha1.to_hex in
  assert (List.equal String.equal piece_hashes expected)

let%test_unit "It should parse the payload type for a single file torrent" =
  assert (
    match Metainfo.payload ubuntu with
    | Single_file _ -> true
    | Directory _ -> false
  )

let%test_unit "It should parse the payload length for a single file torrent" =
  assert (
    match Metainfo.payload ubuntu with
    | Single_file { length } -> Int64.equal length 3116482560L
    | Directory _ -> false
  )


let%test_unit "It should parse the payload type for a multi-file torrent" =
  assert (
    match Metainfo.payload cosmos_laundromat with
    | Single_file _ -> false
    | Directory _ -> true
  )

let%test_unit "It should parse the file lengths for a multi-file torrent" =
  assert (
    match Metainfo.payload cosmos_laundromat with
    | Single_file _ -> false
    | Directory { files } ->
      let file_lengths = List.map ~f:Metainfo.file_length files in
      List.equal Int64.equal file_lengths [
        3945L; 3911L; 4120L; 3945L; 220087570L; 760595L;
      ]
  )

let%test_unit "It should parse the file names for a multi-file torrent" =
  assert (
    match Metainfo.payload cosmos_laundromat with
    | Single_file _ -> false
    | Directory { files } ->
      let file_names = List.map ~f:Metainfo.file_name files in
      List.equal String.equal file_names [
        "Cosmos Laundromat.en.srt";
        "Cosmos Laundromat.es.srt";
        "Cosmos Laundromat.fr.srt";
        "Cosmos Laundromat.it.srt";
        "Cosmos Laundromat.mp4";
        "poster.jpg";
      ]
  )


(* TODO find an example file which actually uses nested directories *)
let%test_unit "It should parse the directory paths for a multi-file torrent" =
  assert (
    match Metainfo.payload cosmos_laundromat with
    | Single_file _ -> false
    | Directory { files } ->
      let file_names = List.map ~f:Metainfo.file_directory_path files in
      List.equal (List.equal String.equal) file_names [[]; []; []; []; []; []]
  )
