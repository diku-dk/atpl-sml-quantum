
open Circuit Diagram Semantics
infix 3 oo
infix 4 **

fun run c k =
    (print ("Circuit for d = " ^ pp c ^ ":\n");
     print (draw c ^ "\n");
     print ("Semantics of d:\n" ^ pp_mat(sem c) ^ "\n");
     print ("Result distribution when evaluating d on " ^ pp_ket k ^ " :\n");
     print (pp_dist(measure_dist(eval c (init k))) ^ "\n\n"))

val () = run (I ** H oo C X oo Z ** Z oo C X oo I ** H) (ket[0,1])

val () = run (I ** X) (ket[0,1])
