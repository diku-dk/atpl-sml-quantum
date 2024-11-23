(** Complex numbers

Semantically, a complex number is a pair of its real part and its imaginary
part, which may not be how it is represented.

*)

signature COMPLEX = sig
  type complex

  val mk       : real * real -> complex
  val fromRe   : real -> complex
  val fromIm   : real -> complex
  val fromInt  : int -> complex

  val conj     : complex -> complex
  val re       : complex -> real
  val im       : complex -> real
  val mag      : complex -> real
  val arg      : complex -> real

  val ~        : complex -> complex
  val +        : complex * complex -> complex
  val -        : complex * complex -> complex
  val *        : complex * complex -> complex
  val /        : complex * complex -> complex
  val <        : complex * complex -> bool
  val >        : complex * complex -> bool
  val >=       : complex * complex -> bool
  val <=       : complex * complex -> bool

  val sqrt     : complex -> complex
  val exp      : complex -> complex
  val ln       : complex -> complex
  val abs      : complex -> complex
  val pow      : complex * complex -> complex
  val fma      : complex * complex * complex -> complex

  val fmt      : StringCvt.realfmt -> complex -> string
  val toString : complex -> string
end

(**

[type complex] The type of complex numbers.

[mk (re,im)] Construct a complex number from real and imaginary components.

[fromRe re] Construct a complex number from just the real component.  The
imaginary part will be zero.

[fromIm im] Construct a complex number from just the imaginary component.  The
real part will be zero.

[fromInt d] Construct a complex number from an integer `d`.  The imaginary part
will be zero.

[conj c] returns the conjugate of c.

[~c] Negate a complex number.

[re c] Extract the real part of a complex number.

[im c] Extract the imaginary part of a complex number.

[mag c] Returns the magnitude (or modulus, or absolute value) of a complex
number.

[arg c] Returns the argument (or phase) of a complex number.

[a + b] Returns the addition of `a` and `b`.

[a - b] Returns `b` subtracted from `a`.

[a * b] Returns `a` multiplied by `b`.

[a / b] Returns `a` divided by `b`.

[a < b] Returns true if the magnitude of `a` is less than the magnitude of `b`.

[a > b] Returns true if the magnitude of `a` is greater than the magnitude of `b`.

[a >= b] Returns true if the magnitude of `a` is greater than or equal to the
magnitude of `b`.

[a <= b] Returns true if the magnitude of `a` is less than or equal to the
magnitude of `b`.

[sqrt c] returns the square root of `c`.

[exp c] returns ethe complex exponentiation of `c`.

[ln c] returns the complex natural logarithm of `c`.

[abs c] returns the absolute value of `c`.

[pow (a,b)] Returns `a` to the power of `b`.

[fma (a,b,c)] returns the complex number `a*b+c`.

*)
