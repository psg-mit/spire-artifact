open Core
module Lir = Lir_

let rec optimize_stmt s =
  let open Lir in
  match s with
  | Sassign _ | Sunassign _ | Sswap _ | Smem_swap _ -> [ s ]
  | Sif (x, ss) ->
    List.map ss ~f:(function
      | Swith (s1, s2) ->
        Swith (List.concat_map ~f:optimize_stmt s1, optimize_stmt @@ Sif (x, s2))
      | Sif (y, ss) ->
        if !Args.disable_nested_if
        then Sif (y, ss)
        else (
          let z = Symbol.nonce () in
          Swith ([ Sassign (Tbool, z, Ebop (Bland, x, y)) ], optimize_stmt @@ Sif (z, ss)))
      | s -> Sif (x, optimize_stmt @@ s))
  | Swith (s1, s2) ->
    [ Swith (List.concat_map ~f:optimize_stmt s1, List.concat_map ~f:optimize_stmt s2) ]
;;

let optimize_modul (m : Lir.modul) : Lir.modul =
  { m with body = List.concat_map ~f:optimize_stmt m.body }
;;
