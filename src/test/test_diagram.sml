val () = print "Testing: Diagram\n"

open Diagram
val H = box "H"
val I = box "I"
val X = box "X"
infix 7 **
infix 3 oo
val op ** = par
val op oo = seq
val d = ((H oo I oo H) ** (H oo X oo I)) oo swap oo cntrl "H"
val d' = H**H oo I**X oo H**I oo swap oo cntrl "H"
val () = print(if toString d = toString d' then "Eq OK\n" else "Eq Err\n")
val d2 = d ** (I oo H)
val () = print (toString d2 ^ "\n")
