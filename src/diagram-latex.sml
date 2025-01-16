structure DiagramLatex :> DIAGRAM = struct

  datatype t = Box of string
             | Line
             | Cntrl of string
             | Swap
             | Par of t * t
             | Seq of t * t

  fun depth t : int =
      case t of
          Line => 1
        | Box _ => 1
        | Cntrl _ => 1
        | Swap => 1
        | Par (t1,t2) => Int.max(depth t1, depth t2)
        | Seq(t1,t2) => depth t1 + depth t2

  fun height t : int =
      case t of
          Line => 1
        | Box _ => 1
        | Cntrl _ => 2
        | Swap => 2
        | Par (t1,t2) => height t1 + height t2
        | Seq(t1,t2) => Int.max(height t1, height t2)

  val dy = 10
  val dx = 10

  fun i2s x = if x < 0 then "-" ^ i2s (~x)
              else Int.toString x

  fun put (x,y) c =
      "\\put(" ^ i2s x ^ "," ^ i2s y ^ "){" ^ c ^ "}"

  fun circ () = "\\circle*{" ^ i2s (dy div 10) ^ "}"

  fun line (x,y) l =
      "\\line(" ^ i2s x ^ "," ^ i2s y ^ "){" ^ i2s l ^ "}"

  fun framebox (sx,sy) s =
      "\\framebox(" ^ i2s sx ^ "," ^ i2s sy ^ "){" ^ s ^ "}"

  fun put_line (x,y) a =
      put (x,y + dy div 2) (line (1,0) dx) :: a

  fun put_swap (x,y) a =
      let val (x1,y1) = (x + dx div 2, y + dy div 2)
          val (x2,y2) = (x1,y1-dy)
      in put_line (x,y)
          (put_line (x,y-dy)
            (put (x1,y2) (line (0,1) dy) ::
             put (x1,y1) (circ()) ::
             put (x2,y2) (circ()) :: a))
      end

  fun put_cntrl (x,y) a =
      let val (x1,y1) = (x + dx div 2, y + dy div 2)
          val dy' = dy - 3 * dy div 10
      in put_line (x,y)
           (put (x1,y1) (line (0,~1) dy') ::
            put (x1,y1) (circ()) :: a)
      end

  fun put_box s (x,y) a =
      let val dx' = dx div 5
          val x' = x + dx'
          val dy' = dy div 5
          val y' = y + dy'
          val sx = dx - 2 * dx'
          val sy = dy - 2 * dy'
      in put (x',y') (framebox(sx,sy) s) ::
         put (x,y + dy div 2) (line(1,0) dx') ::
         put (x+dx,y + dy div 2) (line(~1,0) dx') :: a
      end

  fun lines n =
      if n > 1 then Par(Line,lines(n-1))
      else Line

  fun padl t =
      Seq(lines (height t), t)

  fun padr t =
      Seq(t,lines (height t))

  fun toStr x y t a =
      case t of
          Box s => put_box s (x,y) a
        | Line => put_line (x,y) a
        | Swap => put_swap (x,y) a
        | Cntrl s => put_box s (x,y - dy) (put_cntrl (x,y) a)
        | Seq (t1,t2) => toStr (x + dx*(depth t1)) y t2 (toStr x y t1 a)
        | Par (t1,t2) =>
          let val d1 = depth t1
              val d2 = depth t2
          in if d1 > d2 + 1 then
               toStr x y (Par(t1,padl (padr t2))) a
             else if d1 > d2 then
               toStr x y (Par(t1,padl t2)) a
             else if d2 > d1 + 1 then
               toStr x y (Par(padl (padr t1),t2)) a
             else  if d2 > d1 then
               toStr x y (Par(padl t1,t2)) a
             else
               toStr x (y - dy*(height t1)) t2 (toStr x y t1 a)
          end

  fun toString t =
      let val (h,d) = (height t, depth t)
      in String.concatWith "\n"
                           ("\\begin{picture}(" ^ i2s (dx*d) ^ "," ^ i2s (dy*h) ^ ")(0,0)" ::
                            toStr 0 ((h-1)*dy) t ["\\end{picture}"])
      end

  val box = Box
  val line = Line
  val cntrl = Cntrl
  val swap = Swap
  val seq = Seq
  val par = Par

end
