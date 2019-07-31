(*
 * Type inference
 *)

open Environ
open Evd
open Constr

(*
 * Type inference
 *
 * Current implementation may cause universe leaks, which will just cause
 * conservative failure of the plugin (TODO)
 *)
val infer_type : env -> evar_map -> types -> types

(* Safely infer the WHNF type of a term, updating the evar map. *)
val e_infer_type : env -> evar_map ref -> constr -> constr

(* Safely infer the sort of a term, updating the evar map. *)
val e_infer_sort : env -> evar_map ref -> constr -> Sorts.family
