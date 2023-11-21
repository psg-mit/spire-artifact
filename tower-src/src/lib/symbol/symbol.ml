open Core
module Table = Int.Table
module Map = Int.Map
module Set = Int.Set

type t = int [@@deriving show, eq]

let sym_to_name, name_to_sym = Table.create (), String.Table.create ()

let get_sym (data : string) : t =
  match Hashtbl.find name_to_sym data with
  | Some sym -> sym
  | None ->
    let key = Hashtbl.length sym_to_name in
    Hashtbl.add_exn sym_to_name ~key ~data;
    Hashtbl.add_exn name_to_sym ~key:data ~data:key;
    key
;;

let nonce () : t =
  let key = Hashtbl.length sym_to_name in
  Hashtbl.add_exn sym_to_name ~key ~data:("@" ^ Int.to_string key);
  key
;;

let name = Hashtbl.find_exn sym_to_name
