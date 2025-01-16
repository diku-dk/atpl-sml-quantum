signature CIRCUIT = sig

  datatype t = I | X | Y | Z | H | T | SW
             | C of t
             | Tensor of t * t
             | Seq of t * t

  val ++         : t * t -> t
  val **         : t * t -> t

  val pp         : t -> string
  val draw       : t -> string
  val draw_latex : t -> string
  val height     : t -> int

end
