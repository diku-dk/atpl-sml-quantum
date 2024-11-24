
open Circuit Semantics
infix 3 oo
infix 4 **

fun run c k =
    (print ("Circuit for c = " ^ pp c ^ ":\n");
     print (draw c ^ "\n");
     print ("Semantics of c:\n" ^ pp_mat(sem c) ^ "\n");
     print ("Result distribution when evaluating c on " ^ pp_ket k ^ " :\n");
     print (pp_dist(measure_dist(eval c (init k))) ^ "\n\n"))

val () = run ((I ** H oo C X oo Z ** Z oo C X oo I ** H) ** I oo I ** SW oo C X ** Y) (ket[1,0,1])
