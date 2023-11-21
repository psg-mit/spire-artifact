module Ast = Ast_

type id = Ast.id [@@deriving show, eq]
type ptr = int [@@deriving show, eq]
type typ = Ast.typ [@@deriving show, eq]

type value =
  | Vvar of id
  | Vunit
  | Vnum of int
  | Vbool of bool
  | Vnull
  | Vptr of typ * ptr
  | Vprod of value list
[@@deriving show, eq]

type uop = Ast.uop [@@deriving show, eq]
type bop = Ast.bop [@@deriving show, eq]
type bound = Ast.bound [@@deriving show, eq]

type call =
  { name : id
  ; bound : bound option
  ; args : value list
  }
[@@deriving show, eq]

type exp =
  | Eval of value
  | Eproj of id * int
  | Euop of uop * id
  | Ebop of bop * id * id
  | Ealloc of typ
  | Efun of call
[@@deriving show, eq]

type stmt =
  | Sseq of stmt list
  | Sassign of id * exp
  | Sunassign of id * exp
  | Sswap of id * id
  | Smem_swap of id * id
  | Sif of id * stmt * stmt
  | Swith of stmt * stmt
  | Sdebug
[@@deriving show, eq]

type id_typ = Ast.id_typ [@@deriving show, eq]

type func =
  { name : id
  ; bound : bound option
  ; args : id_typ list
  ; result : id_typ
  ; body : stmt
  }
[@@deriving show, eq]

type static =
  { name : id
  ; elt_type : typ
  ; values : value list
  }
[@@deriving show, eq]

type decl =
  | Dstatic of static
  | Dtype of id_typ
  | Dfunc of func
[@@deriving show, eq]
