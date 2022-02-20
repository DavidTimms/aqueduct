open! Core

type t = {
  index : int;
  hash : Sha1.t;
  mutable downloaded : bool;
}

let init ~index ~hash =
  {
    index;
    hash;
    downloaded = false;
  }
