val () = print "Testing: Circuit\n"

open Circuit
infix 4 **
infix 3 oo

val c = X ** H oo I ** Y oo SW oo Y ** H

val () = print (draw c ^ "\n")
