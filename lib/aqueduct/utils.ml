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

let random_safe_char () =
  let rand = Random.int 62 in
  let char_code =
    if rand < 10 then rand + 48 else
    if rand < 36 then rand + 55 else
    rand + 61
  in
  Char.unsafe_of_int char_code

let rec random_string length =
  if length = 0 then
    ""
  else
    (Char.to_string (random_safe_char ())) ^ random_string (length - 1)
