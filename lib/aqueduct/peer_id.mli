open! Core

type t

val to_string : t -> string

val from_string : string -> t option

val random : unit -> t
