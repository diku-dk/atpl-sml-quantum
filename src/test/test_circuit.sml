val () = print "Testing: Circuit\n"

open Circuit
infix 4 **
infix 3 ++

val c = X ** H ++ I ** Y ++ SW ++ Y ** H

val () = print (draw c ^ "\n")
