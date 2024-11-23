
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
  val eval     : Circuit.t -> state -> state

  type dist = (ket*real) vector
  val pp_dist      : dist -> string
  val measure_dist : state -> dist
end
