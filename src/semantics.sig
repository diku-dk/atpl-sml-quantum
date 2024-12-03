
signature SEMANTICS =
sig
  type mat = Complex.complex Matrix.t
  val pp_mat : mat -> string
  val sem    : Circuit.t -> mat

  eqtype ket
  val ket    : int list -> ket
  val pp_ket : ket -> string

  type state
  val pp_state : state -> string
  val init     : ket -> state
  val eval     : Circuit.t -> state -> state (* use sem *)

  type dist = (ket*real) vector
  val pp_dist      : dist -> string
  val measure_dist : state -> dist

  val interp : Circuit.t -> state -> state
end

(**

[interp t v] uses vectorisation magic to avoid Kronecker products. Using
   1. (A ** B) v = vec(B V A^), where V = unvec v
   2. (B V) A^ = (A (B V)^)^
we have
   3. (A ** B) v = vec((A (B V)^)^),   where V = unvec v


*)
