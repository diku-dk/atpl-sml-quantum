val () = print "Testing: Semantics\n"

open Circuit Semantics
infix 4 ** infix 3 oo

fun err s = raise Fail ("TestSemantics: " ^ s)

fun testKetSpace (k:ket, sp:string) =
    let val s = init k
    in if pp_state s = sp then ()
       else err ("testKetSpace: Wrong state for ket " ^ pp_ket k ^ " : "
                 ^ pp_state s ^ " - expecting " ^ sp ^ "\n")
    end

val () = List.app testKetSpace
                  [(ket[0,0], "1 0 0 0"),
                   (ket[0,1], "0 1 0 0"),
                   (ket[1,0], "0 0 1 0"),
                   (ket[1,1], "0 0 0 1"),
                   (ket[0], "1 0"),
                   (ket[1], "0 1"),
                   (ket[1,0,1], "0 0 0 0 0 1 0 0")]

fun distFindMax (d:dist) : (ket*real) option =
    Vector.foldl (fn ((k,r), a as SOME(k',r')) => if r > r' then SOME(k,r)
                                                  else a
                   | (p, NONE) => SOME p) NONE d

fun testDist (k:ket) : unit =
    let val s = init k
        val d = measure_dist s
    in case distFindMax d of
           NONE => err "testDist: Empty dist"
         | SOME (k',_) =>
           if k <> k'
           then err ("testDist: init state not observed - got " ^ pp_ket k')
           else ()
    end

val () = List.app testDist [ket[0,1,1],
                            ket[1,0,1]]

fun run t (g:t) (k:ket) : unit =
    let val () = print ("*** Example: " ^ t ^ "\n")
        val () = print ("Diagram of g = " ^ pp g ^ ":\n")
        val () = print (draw g ^ "\n")
        val () = print ("Semantics:\n")
        val () = print (pp_mat (sem g) ^ "\n")
        val s = init k
        val () = print ("Initial state of " ^ pp_ket k ^ ": " ^ pp_state s ^ "\n")
        val s' = eval g s
        val () = print ("eval g " ^ pp_ket k ^ " = " ^ pp_state s' ^ "\n")
        val () = print ("State Distribution:\n")
        val () = print (pp_dist(measure_dist s') ^ "\n")
        val () = print ("Testing interpretation against semantics: ")
        val s'' = interp g s
        val () = if pp_state s'' = pp_state s' then print "OK\n"
                 else print "ERR\n"
        val () = print "***\n"
    in ()
    end

val () = run "Double Beam-Splitter" (H oo H) (ket[0])

val () = run "Two Qubits (NOT on second qubit)" ((H oo H) ** X) (ket[0,1])

val () = run "Two Qubits Swapped" ((H oo H) ** X oo SW) (ket[0,1])

val () = run "Swap" (I ** SW oo SW ** I) (ket[0,1,1])

val () = run "SwapSwap" (SW oo X ** X oo SW) (ket[1,0])

val () = run "Swap with Y" (SW oo Y ** X oo SW) (ket[1,0])

val () = print "The following two systems are identical\n"
val () = run "System 1" ((I ** H) oo C X oo (Z ** Z) oo C X oo (I ** H)) (ket[1,0])
val () = run "System 2" (I ** X) (ket[1,0])
