val () = print "Testing: Diagram\n"

open Diagram
val H = box "H"
val I = box "I"
val X = box "X"
infix 3 ++
infix 4 **
val op ** = par
val op ++ = seq
val d = ((H ++ I ++ H) ** (H ++ X ++ I)) ++ swap ++ cntrl "H"
val d' = H**H ++ I**X ++ H**I ++ swap ++ cntrl "H"
val () = print(if toString d = toString d' then "Eq OK\n" else "Eq Err\n")
val d2 = d ** (I ++ H)
val () = print (toString d2 ^ "\n")
