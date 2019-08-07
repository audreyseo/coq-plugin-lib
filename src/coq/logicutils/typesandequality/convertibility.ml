(*
 * Convertibility
 *)

open Constr
open Contextutils
open Utilities
open Environ
open Evd
open Inference

(* Checks whether two terms may be convertible *)
let convertible env sigma trm1 trm2 : bool =
  let etrm1 = EConstr.of_constr trm1 in
  let etrm2 = EConstr.of_constr trm2 in
  snd (Reductionops.infer_conv env sigma etrm1 etrm2)

(*
 * Checks whether the conclusions of two dependent types are convertible,
 * modulo the assumption that every argument we encounter is equal when
 * the types of those arguments are convertible. Expect exactly the same
 * number of arguments in the same order.
 *)
let rec concls_convertible (env : env) (evd : evar_map) (typ1 : types) (typ2 : types) : bool =
  match (kind typ1, kind typ2) with
  | (Prod (n1, t1, b1), Prod (n2, t2, b2)) ->
     if convertible env evd t1 t2 then
       concls_convertible (push_rel CRD.(LocalAssum(n1, t1)) env) evd b1 b2
     else
       false
  | _ ->
     convertible env evd typ1 typ2

(* Checks whether the types of two terms are convertible *)
let types_convertible env sigma trm1 trm2 : bool =
  try
    let sigma, typ1 = infer_type env sigma trm1 in
    let sigma, typ2 = infer_type env sigma trm2 in
    convertible env sigma typ1 typ2
  with _ -> false
