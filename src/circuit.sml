structure Circuit : CIRCUIT = struct

  infix |> fun a |> f = f a

  datatype t = I | X | Y | Z | H | T | SW
             | Tensor of t * t
             | Seq of t * t
             | C of t

  val ++ = op Seq
  val ** = op Tensor

  fun pp t =
      let fun maybePar P s = if P then "(" ^ s ^ ")" else s
          fun pp p t =
              case t of
                  Tensor(t1,t2) => maybePar (p > 4) (pp 4 t1 ^ " ** " ^ pp 4 t2)
                | Seq(t1,t2) => maybePar (p > 3) (pp 3 t1 ^ " ++ " ^ pp 3 t2)
                | C t => "C" ^ pp 8 t
                | I => "I" | X => "X" | Y => "Y" | Z => "Z" | H => "H" | T => "T" | SW => "SW"
    in pp 0 t
    end

  fun draw t =
      let fun dr t =
              case t of
                  SW => Diagram.swap
                | Tensor(a,b) => Diagram.par(dr a, dr b)
                | Seq(a,b) => Diagram.seq(dr a, dr b)
                | I => Diagram.line
                | X => Diagram.box "X"
                | Y => Diagram.box "Y"
                | Z => Diagram.box "Z"
                | H => Diagram.box "H"
                | T => Diagram.box "T"
                | C X => Diagram.cntrl "X"
                | C Y => Diagram.cntrl "Y"
                | C Z => Diagram.cntrl "Z"
                | C H => Diagram.cntrl "H"
                | C _ => raise Fail ("Circuit.draw: Controlled circuit " ^
                                     pp t ^ " cannot be drawn")
      in dr t |> Diagram.toString
      end

  structure DiagramL = DiagramLatex

  fun draw_latex t =
      let fun dr t =
              case t of
                  SW => DiagramL.swap
                | Tensor(a,b) => DiagramL.par(dr a, dr b)
                | Seq(a,b) => DiagramL.seq(dr a, dr b)
                | I => DiagramL.line
                | X => DiagramL.box "X"
                | Y => DiagramL.box "Y"
                | Z => DiagramL.box "Z"
                | H => DiagramL.box "H"
                | T => DiagramL.box "T"
                | C X => DiagramL.cntrl "X"
                | C Y => DiagramL.cntrl "Y"
                | C Z => DiagramL.cntrl "Z"
                | C H => DiagramL.cntrl "H"
                | C _ => raise Fail ("Circuit.draw_latex: Controlled circuit " ^
                                     pp t ^ " cannot be drawn")
      in dr t |> DiagramL.toString
      end

  fun height t =
      case t of
          Tensor(a,b) => height a + height b
        | Seq(a,b) =>
          let val d = height a
          in if d <> height b
             then raise Fail "Sequence error: mismatching dimensions"
             else d
          end
        | SW =>  2
        | C t => 1 + height t
        | _ => 1

end
