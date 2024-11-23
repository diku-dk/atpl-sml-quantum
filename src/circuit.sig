signature CIRCUIT = sig

  datatype t = I | X | Y | Z | H | SW
             | C of t
             | Tensor of t * t
             | Seq of t * t

  val oo   : t * t -> t
  val **   : t * t -> t

  val pp   : t -> string
  val draw : t -> string
  val dim  : t -> int

end
