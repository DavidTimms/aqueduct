open! Core

let cosmos_laundromat =
  Metainfo.from_file "../../samples/cosmos-laundromat.torrent"

  let ubuntu =
    Metainfo.from_file "../../samples/ubuntu.iso.torrent"

let%test_unit "It should parse the tracker URL from the 'announce' field" =
  let tracker_url = Metainfo.tracker_url cosmos_laundromat in
  assert (String.equal tracker_url "udp://tracker.leechers-paradise.org:6969")

let%test_unit "It should parse the suggested name from the 'info.name' field" =
  let suggested_name = Metainfo.suggested_name cosmos_laundromat in
  assert (String.equal suggested_name "Cosmos Laundromat")

let%test_unit "It should parse the piece length from the 'info.piece length' field" =
  let piece_length = Metainfo.piece_length cosmos_laundromat in
  assert (Int64.equal piece_length 262144L)

let%test_unit "It should parse the piece hashes from the 'info.pieces' field" =
  let piece_hashes = Metainfo.piece_hashes cosmos_laundromat in
  let expected = TestData.cosmos_laundromat_piece_hashes in
  assert (List.equal Sha1.equal piece_hashes expected)

let%test_unit "It should parse the payload type for a multi-file torrent" =
  assert (
    match Metainfo.payload cosmos_laundromat with
    | Single_file _ -> false
    | Directory _ -> true
  )

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
