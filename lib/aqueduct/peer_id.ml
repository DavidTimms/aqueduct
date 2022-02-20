open! Core
open Utils

type t = string

let to_string peer_id = peer_id

let from_string peer_id =
  if (String.length peer_id) = 20 then
    Some peer_id
  else
    None

let random () = random_string 20
