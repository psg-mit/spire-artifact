open Printf
open Voqc.Qasm
open Voqc.Main

(* Argument parsing *)
let f = ref ""
let o = ref ""
let light = ref false
let usage = "usage: " ^ Sys.argv.(0) ^ " -f string"
let speclist = [
    ("-f", Arg.Set_string f, ": input program");
    ("-o", Arg.Set_string o, ": output program");
    ("--light", Arg.Set light, ": use light optimization")
  ]
let () =
  Arg.parse
    speclist
    (fun x -> raise (Arg.Bad ("Bad argument : " ^ x)))
    usage;
if !f = "" then printf "ERROR: Input file (-f) required.\n" else

(* Read input file *)
let _ = printf "Reading input %s\n%!" !f in
let (c0, n) = read_qasm !f in
let _ = printf "Input circuit has %d gates and uses %d qubits.\n%!" (count_total c0) n in

(* Optimize *)
let c1 = if !light then optimize_nam_light c0 else optimize_nam c0 in
printf "After optimization, the circuit uses %d gates : { H : %d, X : %d, Rzq : %d, CX : %d }.\n%!"
          (count_total c1) (count_H c1) (count_X c1) (count_Rzq c1) (count_CX c1);

write_qasm c1 n !o
