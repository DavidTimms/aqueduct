open! Core

module Sha1_map = Map.Make(struct
  type t = Sha1.t
  let compare a b = String.compare (Sha1.to_bin a) (Sha1.to_bin b)
  let t_of_sexp sexp = Sha1.string (String.t_of_sexp sexp)

  let sexp_of_t sha1 = String.sexp_of_t (Sha1.to_bin sha1)
end)

type t = {
  metainfo : Metainfo.t;
  peer_id : Peer_id.t;
  listen_port : int;
  mutable uploaded : int64;
  mutable downloaded: int64;
  pieces : Piece.t Sha1_map.t;
}

let init metainfo =
  {
    metainfo;
    peer_id = Peer_id.random ();
    listen_port = 6881;
    uploaded = 0L;
    downloaded = 0L;
    (* TODO populate pieces map from metainfo *)
    pieces = Sha1_map.empty;
  }
