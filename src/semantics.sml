structure Semantics :> SEMANTICS = struct

  infix |> fun x |> f = f x

  structure C = Complex
  structure M = Matrix

  type complex = C.complex
  type mat = C.complex M.t

  fun pp_c (c:complex) : string =
      C.fmtBrief (StringCvt.GEN(SOME 4)) c

  fun pp_mat (m:mat) : string =
      let val m = M.map pp_c m
          val sz = foldl (fn (e,a) => Int.max(a,size e)) 1
                         (List.concat (M.listlist m))
      in M.pp sz (fn x => x) m
      end

  (* Semantics *)
  fun matmul (t1:mat,t2:mat) : mat =
      M.matmul_gen C.* C.+ (C.fromInt 0) t1 t2

  (* See https://en.wikipedia.org/wiki/Kronecker_product *)
  fun tensor (a: mat,b:mat) : mat =
      let val m = M.nRows a
          val n = M.nCols a
          val p = M.nRows b
          val q = M.nCols b
      in M.tabulate(m * p, n * q,
                     fn (i,j) =>
                        C.* (M.sub(a,i div p, j div q),
                             M.sub(b,i mod p, j mod q))
                   )
      end

  (* Generalised control - see Feynman '59:
     https://iontrap.umd.edu/wp-content/uploads/2016/01/Quantum-Gates-c2.pdf,
     section 2.5.7
   *)
  fun control (m: mat) : mat =
      let val n = M.nRows m
      in M.tabulate(2*n,2*n,
                    fn (r,c) =>                        (* 1 0 0 0 *)
                       if r >= n andalso c >= n        (* 0 1 0 0 *)
                       then M.sub(m,r-n,c-n)           (* 0 0 a b *)
                       else if r = c then C.fromInt 1  (* 0 0 c d *)
                       else C.fromInt 0)
      end

  fun fromIntM iss : mat =
      M.fromListList (map (map C.fromInt) iss)

  fun sem (t:Circuit.t) : mat =
      let open Circuit
          val c0 = C.fromInt 0
          val c1 = C.fromInt 1
          val cn1 = C.~ c1
          val ci = C.fromIm 1.0
          val cni = C.~ ci
      in case t of
             I => fromIntM [[1,0],
                            [0,1]]
           | X => fromIntM [[0,1],
                            [1,0]]
           | Y => M.fromListList [[c0,cni],
                                  [ci,c0]]
           | Z => fromIntM [[1,0],[0,~1]]
           | H => let val rsqrt2 = C.fromRe (1.0 / Math.sqrt 2.0)
                  in M.fromListList [[rsqrt2,rsqrt2],
                                     [rsqrt2,C.~ rsqrt2]]
                  end
           | SW => fromIntM [[1,0,0,0],
                             [0,0,1,0],
                             [0,1,0,0],
                             [0,0,0,1]]
           | Seq(t1,t2) => matmul(sem t2,sem t1)
           | Tensor(t1,t2) => tensor(sem t1,sem t2)
           | C t => control (sem t)
      end

  type ket = int list (* list of 0's and 1's *)
  fun ket xs = xs
  fun pp_ket (v:ket) : string =
      "|" ^ implode (map (fn i => if i > 0 then #"1" else #"0") v) ^ ">"

  type state = complex vector

  fun log2 n = if n <= 1 then 0 else 1 + log2(n div 2)
  fun pow2 n = if n <= 0 then 1 else 2 * pow2(n-1)

  fun init (is: ket) : state =
      let val i = foldl (fn (x,a) => 2 * a + x) 0 is
      in Vector.tabulate(pow2 (length is),
                         fn j => if i = j then C.fromInt 1 else C.fromInt 0)
      end

  fun pp_state (v:state) : string =
      let val v = Vector.map pp_c v
          val sz = Vector.foldl (fn (e,a) => Int.max(a,size e)) 1 v
      in M.ppv sz (fn x => x) v
      end

  fun eval (x:Circuit.t) (v:state) : state =
      M.matvecmul_gen C.* C.+ (C.fromInt 0) (sem x) v

  (* Probability distributions *)

  type dist = (ket*real) vector

  fun pp_dist (d:dist) : string =
      Vector.foldr (fn ((k,r),a) =>
                       (pp_ket k ^ " : " ^ Real.toString r) :: a) nil d
                   |> String.concatWith "\n"

  fun toKet (n:int, i:int) : ket =
      (* state i \in [0;2^n-1] among total states 2^n, in binary *)
      let val s = StringCvt.padLeft #"0" n (Int.fmt StringCvt.BIN i)
      in CharVector.foldr (fn (#"1",a) => 1::a | (_,a) => 0::a) nil s
      end

  fun dist (s:state) : real vector =
      let fun square r = r*r
      in Vector.map (square o Complex.mag) s
      end

  fun measure_dist (s:state) : dist =
      let val v = dist s
          val n = log2 (Vector.length s)
      in Vector.mapi (fn (i,p) => (toKet(n,i), p)) v
      end
end
