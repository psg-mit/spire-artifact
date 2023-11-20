open Core
module WireTable = Int.Table
module Circuit = Circuit_

exception OutOfMemory
exception NullDereference

module State = struct
  type t =
    { reg : bool WireTable.t
    ; mem : int array
    ; hp : int array
    }

  let init ~mem_size =
    { reg = WireTable.create ()
    ; mem = Array.init mem_size ~f:(fun i -> if i = mem_size - 1 then 0 else i + 1)
    ; hp = Array.init !Args.word_size ~f:(fun _ -> 0)
    }
  ;;

  let show_reg state =
    Hashtbl.to_alist state.reg
    |> List.sort ~compare:(fun (i1, _) (i2, _) -> Int.compare i1 i2)
    |> List.map ~f:(fun (i, v) -> Format.sprintf "%d -> %s" i (Bool.to_string v))
    |> String.concat ?sep:(Some ", ")
    |> fun s -> "{ " ^ s ^ " }"
  ;;

  let show_mem state =
    Array.to_list state.mem
    |> List.map ~f:Int.to_string
    |> String.concat ?sep:(Some "; ")
    |> fun s -> "[ " ^ s ^ " ]"
  ;;

  let debug state =
    Format.eprintf
      "*** DEBUG ***\nRegister: %s\nMemory: %s\n%!"
      (show_reg state)
      (show_mem state)
  ;;

  let get_reg state k =
    match Hashtbl.find state.reg k with
    | Some x -> x
    | _ -> if !Args.optimize_lir then false else assert false
  ;;

  let has_reg state = Hashtbl.mem state.reg
  let is_unset state w = not (get_reg state w)

  let xor_reg state key data =
    Hashtbl.change state.reg key ~f:(function
      | None -> Some data
      | Some x -> Some Bool.(x <> data))
  ;;

  let del_reg state key = Hashtbl.remove state.reg key
  let get_mem state p = state.mem.(p)
  let xor_mem state p v = state.mem.(p) <- state.mem.(p) lxor v

  let get_word state ws =
    List.map ws ~f:(get_reg state)
    |> List.map ~f:(fun x -> if x then "1" else "0")
    |> String.concat ~sep:""
    |> String.rev
    |> fun s -> "0b" ^ s |> Int.of_string
  ;;

  let xor_word state ws n =
    let bits = List.init (List.length ws) ~f:(fun i -> n land (1 lsl i) <> 0) in
    List.iter2_exn ws bits ~f:(fun w b -> xor_reg state w b)
  ;;

  let alloc state hp =
    let p = get_word state hp in
    let v = state.mem.(p) in
    if v = 0
    then raise OutOfMemory
    else (
      state.mem.(p) <- 0;
      xor_word state hp v;
      p)
  ;;

  let dealloc state hp p =
    state.mem.(p) <- get_word state hp;
    xor_word state hp p
  ;;
end

let check_regs_cleared (state : State.t) out_arg =
  let remaining = state.reg |> Hashtbl.keys |> Int.Set.of_list in
  let out_arg = out_arg |> Int.Set.of_list in
  let remaining = Set.diff (Set.diff remaining out_arg) (Int.Set.of_array state.hp) in
  if !Args.optimize_lir
  then (
    let remaining = Set.filter remaining ~f:(State.get_reg state) in
    if not (Set.is_empty remaining)
    then (
      State.debug state;
      Format.eprintf
        "Warning: some registers were not cleared at program termination: %s\n%!"
        (Set.to_list remaining |> List.map ~f:Int.to_string |> String.concat ~sep:", "))
    else assert (Set.is_empty remaining))
;;

let rec exec_gate (state : State.t) fwd s =
  match s with
  | Circuit.Gnum (n, ws) ->
    if not !Args.optimize_lir
    then
      if fwd
      then assert (List.for_all ws ~f:(State.is_unset state))
      else assert (n = State.get_word state ws);
    State.xor_word state ws n
  | Gbool (b, w) ->
    if not !Args.optimize_lir
    then
      if fwd
      then assert (State.is_unset state w)
      else assert (Bool.(b = State.get_reg state w));
    State.xor_reg state w b
  | Gnot ws -> List.iter ws ~f:(fun w -> State.xor_reg state w true)
  | Gcopy (ws1, ws2) ->
    if not !Args.optimize_lir
    then
      if fwd
      then assert (List.for_all ws2 ~f:(State.is_unset state))
      else
        List.iter2_exn ws1 ws2 ~f:(fun w1 w2 ->
          assert (Bool.(State.get_reg state w1 = State.get_reg state w2)));
    List.iter2_exn ws1 ws2 ~f:(fun w1 w2 ->
      State.xor_reg state w2 @@ State.get_reg state w1)
  | Gbop (bop, ws1, ws2, ws3) ->
    let x = State.get_word state ws1 in
    let y = State.get_word state ws2 in
    let n = 1 lsl !Args.word_size in
    let res =
      match bop with
      | Bland -> x land y
      | Blor -> x lor y
      | Beq -> if x = y then 1 else 0
      | Blsl -> (x lsl y) mod n
      | Blsr -> x lsr y
      | Bplus -> (x + y) mod n
      | Bminus -> (x - y + n) mod n
      | Btimes -> x * y mod n
      | Bless -> if x < y then 1 else 0
    in
    if not !Args.optimize_lir
    then
      if fwd
      then assert (List.for_all ws3 ~f:(State.is_unset state))
      else assert (State.get_word state ws3 = res);
    State.xor_word state ws3 res
  | Gswap (ws1, ws2) ->
    List.iter2_exn ws1 ws2 ~f:(fun w1 w2 ->
      let w2old, w1old = State.get_reg state w2, State.get_reg state w1 in
      State.xor_reg state w1 (State.get_reg state w2);
      State.xor_reg state w2 (State.get_reg state w1);
      State.xor_reg state w1 (State.get_reg state w2);
      let w2new, w1new = State.get_reg state w2, State.get_reg state w1 in
      assert (Bool.(w2old = w1new) && Bool.(w1old = w2new)))
  | Gmem_swap (ws1, ws2) ->
    let p = State.get_word state ws1 in
    if p = 0 || p >= Array.length state.mem
    then (if not !Args.optimize_lir then raise NullDereference)
    else (
      let memold, ws2old = State.get_mem state p, State.get_word state ws2 in
      State.xor_mem state p @@ State.get_word state ws2;
      State.xor_word state ws2 @@ State.get_mem state p;
      State.xor_mem state p @@ State.get_word state ws2;
      let memnew, ws2new = State.get_mem state p, State.get_word state ws2 in
      assert (memold = ws2new && ws2old = memnew))
  | Gcond (w, gs) -> if State.get_reg state w then List.iter gs ~f:(exec_gate state fwd)
  | Gconj gs -> List.rev gs |> List.iter ~f:(exec_gate state (not fwd))
  | Ginit w ->
    if fwd
    then State.xor_reg state w false
    else if not !Args.optimize_lir
    then State.del_reg state w
;;

let check_leaks (state : State.t) mem_size =
  let initial = State.init ~mem_size in
  let initial_mem = Set.add (Int.Set.of_array initial.mem) 1 in
  let final_mem = Set.union (Int.Set.of_array state.mem) @@ Int.Set.of_array state.hp in
  Set.equal initial_mem final_mem && Array.mem ~equal:Int.equal state.mem 0
;;

let interp ~mem_size (modules : Circuit.modul list) =
  let state = State.init ~mem_size in
  List.iter modules ~f:(fun m ->
    if m.name = Symbol.get_sym "main"
    then (
      assert (List.is_empty m.args);
      List.iteri m.hp ~f:(fun i w -> state.hp.(i) <- w);
      State.xor_word state m.hp 1;
      List.iter m.body ~f:(exec_gate state true);
      check_regs_cleared state m.out_args;
      if not (check_leaks state mem_size)
      then
        Format.eprintf
          "Warning: memory may not have been reset to initial state at program \
           termination.\n"
      else Format.eprintf "Exited normally.\n"));
  state
;;
