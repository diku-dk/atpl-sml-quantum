
open Circuit Comp
infix 3 oo
infix 4 **

fun comment s =
    print("-- " ^
          String.translate (fn #"\n" => "\n-- " | c => String.str c) s
          ^ "\n")

fun test c =
    ( comment ("Circuit for c = " ^ pp c ^ ":")
    ; comment (draw c)
    ; comment ("Futhark prelude, matrix binding, and simulation function for c:\n")
    ; print (preludeBindings() ^ "\n\n")
    ; print (circuitToFutMatBind "m" c ^ "\n\n")
    ; print (circuitToFutFunBind "f" c ^ "\n\n")
    )

val () = test ((I ** H oo C X oo Z ** Z oo C X oo I ** H) ** I oo I ** SW oo C X ** Y)
