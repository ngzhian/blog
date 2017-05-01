#! /usr/bin/env ocaml

type state =
  | Header
  | Body;;

let front = "---" in
let back = "..." in
let empty = "" in

let add_matter header rest =
  front :: header @ [back; ""] @ rest in

let read file =
  let chn = open_in file in
  let rec read_until chn st h c =
    try
      let line = input_line chn in
      match st with
      | Header ->
        if line = empty
        then read_until chn Body h c
        else read_until chn st (line :: h) c
      | Body ->
        read_until chn st h (line :: c)
    with End_of_file ->
      close_in chn;
      List.rev h, List.rev c
  in
  read_until chn Header [] []
in

let join lines = String.concat "\n" lines ^ "\n" in

let update file =
  let header, rest = read file in
  let lines = add_matter header rest in
  let output = join lines in
  let chn = open_out file in
  output_string chn output;
  close_out chn;
in

let ext = ".mdown" in
let folder = "./posts" in
let is_md filename =
  String.sub filename (String.length filename - String.length ext) (String.length ext) = ext in

(* let files = Sys.readdir folder in *)

let rewrite filename =
  if (is_md filename)
  then update (Filename.concat folder filename)
  else () in

(* recursively traverse and apply fn *)
let rec traverse fp fn =
  Sys.readdir fp
  |> Array.iter (fun filename ->
      if Sys.is_directory (Filename.concat fp filename)
      then traverse filename fn
      else fn filename
    )
in
traverse folder rewrite
