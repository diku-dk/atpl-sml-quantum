
open Circuit Semantics
infix 3 oo
infix 4 **

fun run c k =
    (print ("Circuit for c = " ^ pp c ^ ":\n");
     print (draw c ^ "\n");
     print ("Semantics of c:\n" ^ pp_mat(sem c) ^ "\n");
     print ("Result distribution when evaluating c on " ^ pp_ket k ^ " :\n");
     let val v0 = init k
         val v1 = eval c v0
     in print (pp_dist(measure_dist v1) ^ "\n\n")
      ; print ("V1: " ^ pp_state v1 ^ "\n")
      ; print ("V2: " ^ pp_state (interp c v0) ^ "\n")
     end)

val () = run ((I ** H oo C X oo Z ** Z oo C X oo I ** H) ** I oo I ** SW oo C X ** Y) (ket[1,0,1])
