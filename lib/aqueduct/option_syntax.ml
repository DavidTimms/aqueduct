open Core

let (>>=) = Option.(>>=)

let (>>|) = Option.(>>|)

let (let*) = Option.(>>=)

let (let+) = Option.(>>|)

let return = Option.return
