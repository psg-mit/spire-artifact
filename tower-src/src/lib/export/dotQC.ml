open Core

let show_wires ws =
  List.map ~f:Int.to_string ws
  |> List.map ~f:(fun s -> "q" ^ s ^ "")
  |> String.concat ~sep:" "
;;

let show_gate = function
  | Prim_circuit.Pnot (w, []) -> "X q" ^ Int.to_string w
  | Pnot (w, ws) -> Format.sprintf "tof " ^ show_wires (ws @ [ w ])
;;

let max_qubit = function
  | Prim_circuit.Pnot (w, ws) ->
    List.max_elt ~compare:Int.compare (w :: ws) |> Option.value_exn
;;

let show_modul (m : Prim_circuit.modul) =
  let max_qubit =
    Sequence.map (Prim_circuit.Gates.to_seq m.body) ~f:max_qubit
    |> Sequence.max_elt ~compare:Int.compare
    |> Option.value ~default:0
  in
  let decl =
    List.init (max_qubit + 1) ~f:(fun i -> "q" ^ Int.to_string i)
    |> String.concat ~sep:" "
  in
  let gates =
    Prim_circuit.Gates.to_list m.body |> List.map ~f:show_gate |> String.concat ~sep:"\n"
  in
  Format.sprintf "# %s\n.v %s\nBEGIN\n%s\nEND\n" (Symbol.name m.name) decl gates
;;
