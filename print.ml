open Syntax
open Printf
let rec print_program fmt p =
  fprintf fmt "[\n";
  pp_defs fmt p;
  fprintf fmt "]\n";
and pp_defs fmt = function
  |[] -> ()
  |x::xs ->
    let _ = pp_def fmt x in
    fprintf fmt ",\n";
    pp_defs fmt xs
and pp_def fmt = function
  | DVar (ty, d, (a, b)) ->
     fprintf fmt "offset=%d:\nDVars(int, [%a])" a.Lexing.pos_cnum pp_declar d
  | DFun (ty, Name s, l1, b, (a, _)) ->
     fprintf fmt "offset=%d:\nDFun(int, %s, [%a], \n%a)" a.Lexing.pos_cnum s pp_params l1 pp_block b
and pp_declar fmt = function
  | DeclIdent name ->
     let Name x = name in
     fprintf fmt "%s" x
  | DeclFProto (d, tlist) ->
     fprintf fmt "Fun %a (%a)" pp_declar d pp_types tlist
and pp_types fmt l =
  let _ = List.map (pp_type fmt) l in
  ()
and pp_type fmt = function
  | TInt -> fprintf fmt "int,"
  | TPtr x -> fprintf fmt "*%a" pp_type x
  | _ -> fprintf fmt "unknown type"
and pp_namelist fmt = function
  | [] ->
     fprintf fmt ""
  | (Name n)::ns ->
     fprintf fmt "%s," n;
     pp_namelist fmt ns
and pp_params fmt = function
  | [] ->
     fprintf fmt ""
  | x::xs ->
     pp_param fmt x;
     fprintf fmt ", ";
     pp_params fmt xs
and pp_param fmt (ty, Name v) =
  fprintf fmt "(%a %s)" pp_type ty v
and pp_block fmt = function
  | Block (vs, s) -> fprintf fmt "\n{[local: %a],\n%a}\n" pp_svars vs pp_stmts s
and pp_svars fmt vs =
  let _ =List.map (fun (SVar (t, Name n)) ->
            fprintf fmt "(%a %s)," pp_type t n) vs in
  ()
and pp_stmts fmt = function
  |[] -> ()
  |x::xs ->
    pp_stmt fmt x;fprintf fmt ",\n";pp_stmts fmt xs
and pp_stmt fmt = function
  | SNil ->
     fprintf fmt ";"
  | SWhile (e, b) ->
     fprintf fmt "SWhile(%a, %a)" pp_expr e pp_block b
  | SFor (op1, op2, op3, s) ->
     fprintf fmt "SFor((%a; %a; %a), %a)" pp_op op1 pp_op op2 pp_op op3 pp_block s
  | SIfElse (e, b1, b2) ->
     fprintf fmt "SIfElse(%a, %a, %a)" pp_expr e pp_block b1 pp_block b2
  | SReturn e ->
     fprintf fmt "SReturn(%a)" pp_expr e
  | SExpr e ->
     fprintf fmt "SExpr(%a);" pp_expr e
and pp_op fmt = function
  | Some e -> pp_expr fmt e
  | None -> ()
and pp_exprs fmt= function
  | [] ->
     fprintf fmt ""
  | x::xs ->
     pp_expr fmt x;
     fprintf fmt ",";
     pp_exprs fmt xs;
and pp_expr fmt = function
  | EConst v ->
     fprintf fmt "EConst(%a)" pp_value v
  | EVar (Name str) ->
     fprintf fmt "EVar(%s)" str
  | EAdd (e1, e2) ->
     fprintf fmt "EAdd(%a, %a)" pp_expr e1 pp_expr e2
  | ESub (e1, e2) ->
     fprintf fmt "ESub(%a, %a)" pp_expr e1 pp_expr e2
  | ESubst (e1, e2) ->
     fprintf fmt "ESubst(%a, %a)" pp_expr e1 pp_expr e2
  | EAddr e ->
     fprintf fmt "EAddr(%a)" pp_expr e
  | EMod (e1, e2) ->
     fprintf fmt "EMod(%a, %a)" pp_expr e1 pp_expr e2
  | EApp (Name s, args) ->
     fprintf fmt "EApp(%s, %a)" s pp_exprs args
  | ELt (e1, e2) ->
     fprintf fmt "ELt(%a, %a)" pp_expr e1 pp_expr e2
  | EEq (e1, e2) ->
     fprintf fmt "EEq(%a, %a)" pp_expr e1 pp_expr e2
  | ENeq (e1, e2) ->
     fprintf fmt "ENeq(%a, %a)" pp_expr e1 pp_expr e2
  | _ -> raise (TODO "print pp_expr")
and pp_value fmt = function
  | VInt i ->
     fprintf fmt "VInt(%d)" i
