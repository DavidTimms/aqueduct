open! Core

type todo = unit
let todo = ()

let rec traverse_options (xs : 'a list) ~(f: 'a -> 'b option) : 'b list option =
  match xs with
  | [] -> Some []
  | x :: rest ->
    Option.bind (f x) ~f:(fun fx ->
      traverse_options ~f rest
      |> Option.map ~f:(List.cons fx)
    )
