open! Core

let cosmos_laundromat =
  Metainfo.from_file "../../samples/cosmos-laundromat.torrent"

let%test_unit "It should parse the tracker URL from the 'announce' field" =
  let tracker_url = Metainfo.tracker_url cosmos_laundromat in
  assert (String.equal tracker_url "udp://tracker.leechers-paradise.org:6969")
