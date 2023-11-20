open Core

let verbose = ref false
let interp = ref false
let interp_lir = ref false
let interp_circuit = ref false
let interp_prim = ref false
let inline = ref false
let compile = ref false
let print = ref false
let bounds = String.Table.create ()
let no_circuit = ref false
let no_prim = ref false
let word_size = ref 8
let mem_size = ref 16
let dotQC = ref false
let optimize_lir = ref false
let disable_with_do = ref false
let disable_nested_if = ref false
let timing = ref false

let process_bound s =
  match String.split ~on:':' s with
  | [ name; i ] -> Hashtbl.add_exn bounds ~key:name ~data:(Int.of_string i)
  | _ -> failwith "Expected function:bound"
;;

let speclist =
  [ "-v", Arg.Set verbose, "Run in verbose mode."
  ; "-i", Arg.Set interp, "Run the classical interpreter."
  ; "--interp_lir", Arg.Set interp_lir, "Run the LIR interpreter."
  ; "--interp_circuit", Arg.Set interp_circuit, "Run the circuit interpreter."
  ; "--interp_prim", Arg.Set interp_prim, "Run the primitive circuit interpreter."
  ; "--inline", Arg.Set inline, "Run the inlining pass before the interpreter."
  ; "-c", Arg.Set compile, "Compile the program to LIR, then to a circuit."
  ; "-p", Arg.Set print, "Print the compiler and interpreter outputs."
  ; "-b", Arg.String process_bound, "Set the bound for a given function."
  ; "--no_circuit", Arg.Set no_circuit, "Do not instantiate circuits."
  ; "--no_prim", Arg.Set no_prim, "Do not instantiate primitive circuits."
  ; "--word_size", Arg.Set_int word_size, "Set the word size."
  ; "--mem_size", Arg.Set_int mem_size, "Set the number of cells in the memory."
  ; "--dotQC", Arg.Set dotQC, "Export to .qc format."
  ; "--optimize_lir", Arg.Set optimize_lir, "Optimize the LIR before compilation."
  ; "--disable_with_do", Arg.Set disable_with_do, "Disable the with-do optimization."
  ; ( "--disable_nested_if"
    , Arg.Set disable_nested_if
    , "Disable the nested-if optimization." )
  ; "--timing", Arg.Set timing, "Print timing information."
  ]
;;
