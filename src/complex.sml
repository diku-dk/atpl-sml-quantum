(** Complex numbers *)

structure Complex :> COMPLEX = struct

  type complex = real * real

  fun mk (a: real, b: real) = (a,b)

  fun fromRe (a: real) = (a, 0.0)
  fun fromIm (b: real) = (0.0, b)

  fun fromInt (a: int) = (real a, 0.0)

  fun conj ((a,b): complex) = (a, ~b)
  fun neg ((a,b): complex) = (~a, ~b)
  fun re ((a,_): complex) = a
  fun im ((_,b): complex) = b

  fun add ((a,b): complex, (c,d): complex) = (a + c, b + d)
  fun sub ((a,b): complex, (c,d): complex) = (a - c, b - d)
  fun mul ((a,b): complex, (c,d): complex) = (a * c - b * d, b * c + a * d)

  fun divv ((a,b): complex, (c,d): complex) =
      ((a * c + b * d) / (c * c + d * d),
       (b * c - a * d) / (c * c + d * d))

  fun mag ((a,b): complex) = Math.sqrt (a * a + b * b)

  fun arg ((a,b): complex) = Math.atan2 (b,a)

  fun sqrt ((a,b): complex) =
      let val gamma = Math.sqrt ((a + Math.sqrt (a * a + b * b)) / 2.0)
          val delta = real(Real.sign b) *
                      Math.sqrt ((~a + Math.sqrt (a * a + b * b)) / 2.0)
      in (gamma, delta)
      end

  fun exp ((a,b): complex) =
      let val expx = Math.exp a
      in mk (expx * Math.cos b, expx * Math.sin b)
      end

  fun ln (z: complex) = mk (Math.ln (mag z), arg z)

  fun abs (a: complex) = fromRe (mag a)

  fun fmt f (a,b) =
      if Real.==(b,0.0) then Real.fmt f a
      else if Real.==(a,0.0) then
        Real.fmt f b ^ "i"
      else
        Real.fmt f a ^
        (if b < 0.0 then "-" ^ Real.fmt f (~b) ^ "i"
         else "+" ^ Real.fmt f b ^ "i")

  fun toString c = fmt (StringCvt.GEN NONE) c

  fun (a: complex) < (b: complex) = Real.< (mag a, mag b)
  fun (a: complex) > (b: complex) = Real.> (mag a, mag b)
  fun (a: complex) >= (b: complex) = not(a < b)
  fun (a: complex) <= (b: complex) = not(a > b)

  fun real_fma (a,b,c) : real = a * b + c

  fun fma ((a,b): complex, (c,d): complex, (e,f): complex) =
      let val r = real_fma (a,c,e) - b * d
          val i = real_fma (a,d,real_fma (c,b,f))
      in mk (r,i)
      end

  fun pow ((a,b): complex, (c,d): complex) =
    let val x = a * a + b * b
        val y = Math.pow (x, (c / 2.0)) * Math.exp (~d * arg (a,b))
        val z = c * arg (a,b) + d / 2.0 * Math.ln x
    in (y * Math.cos z,
        y * Math.sin z)
    end

  val ~ = neg
  val op + = add
  val op - = sub
  val op * = mul
  val op / = divv

end
