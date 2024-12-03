signature FUTHARK =
  sig
    type var = string
    type ty = string
    datatype exp = VAR of var
                 | BINOP of string * exp * exp
                 | CONST of string
                 | APP of string * exp list
                 | ARR of exp list
                 | TYPED of exp * ty
                 | SEL of int * exp

    type 'a M
    val ret      : 'a -> 'a M
    val >>=      : 'a M * ('a -> 'b M) -> 'b M
    val newVar   : unit -> var
    val newFVar  : unit -> var
    val LetNamed : var -> exp -> var M
    val FunNamed : var -> (exp -> exp M) -> ty -> ty -> var M
    val Let      : exp -> var M
    val Fun      : (exp -> exp M) -> ty -> ty -> var M
    val run      : exp M -> string
    val runBinds : unit M -> string
  end

structure Futhark :> FUTHARK = struct

  type var = string
  type ty = string
  datatype exp = VAR of var
               | BINOP of string * exp * exp
               | CONST of string
               | APP of string * exp list
               | ARR of exp list
               | TYPED of exp * ty
               | SEL of int * exp

  datatype binding = LET of string * exp
                   | FUN of var * var * ty * ty * binding list * exp

  type 'a M = binding list * 'a

  fun ret v = (nil,v)

  infix >>=

  fun ((bs1,v):'a M) >>= (f: 'a -> 'b M) : 'b M =
      let val (bs2,v) = f v
      in (bs1@bs2,v)
      end

  fun newVarGen (s:string) : unit -> var =
      let val c = ref 0
      in fn () => s ^ Int.toString (!c)
                  before c := !c + 1
      end

  val newVar = newVarGen "v"
  val newFVar = newVarGen "f"

  fun LetNamed (var:string) (e:exp) : var M =
      ([LET(var,e)], var)

  fun Let (e:exp) : var M =
      case e of
          VAR v => ret v
        | _ => LetNamed (newVar()) e

  fun FunNamed (fvar:string) (f:exp -> exp M) (ty:string) (ty':string) : var M =
      let val argvar = newVar()
          val (bs,v) = f (VAR argvar)
      in ([FUN(fvar,argvar,ty,ty',bs,v)],fvar)
      end

  fun Fun (f:exp -> exp M) (ty:string) (ty':string) : var M =
      FunNamed (newFVar()) f ty ty'

  fun prec "+" = 3
    | prec "*" = 4
    | prec _ = 2

  val prec_fun = 8
  val prec_max = 1000

  fun par p x = if p then "(" ^ x ^ ")" else x

  fun indent i s =
      let val sp = CharVector.tabulate(i,fn _ => #" ")
      in sp ^ String.translate (fn #"\n" => "\n" ^ sp | c => String.str c) s
      end

  fun letdef true = "def "
    | letdef false = "let "

  fun pp_binding top (LET (x,e)) = letdef top ^ x ^ " = " ^ pp_exp 0 e
    | pp_binding top (FUN (f,x,ty,ty',bs,e)) =
      let val arg = if ty = "()" then "" else x ^ ":" ^ ty
      in letdef top ^ f ^ " (" ^ arg ^ ") : " ^ ty' ^ " =\n" ^
         indent 2 (pp_bindings_in bs e)
      end

  and pp_bindings_in bs e =
      case bs of
          nil => pp_exp 0 e
        | _ => String.concatWith "\n" (map (pp_binding false) bs)
               ^ "\nin " ^ pp_exp 0 e

  and pp_exp p e =
      case e of
          VAR x => x
        | CONST c => c
        | BINOP (opr,e1,e2) =>
          par (p > prec opr) (pp_exp (prec opr) e1 ^ opr ^
                              pp_exp (prec opr) e2)
        | SEL (i,e) => par (p > 0) (pp_exp prec_max e ^ "." ^ Int.toString i)
        | APP (f,nil) => par (p > prec_fun) (f ^ "()")
        | APP (f,args) =>
          par (p > prec_fun)
              (f ^ " " ^ String.concatWith " " (map (pp_exp prec_max) args))
        | ARR es => "[" ^ String.concatWith "," (map (pp_exp 0) es) ^ "]"
        | TYPED (e,ty) => par (p > 0) (pp_exp prec_max e ^ ":>" ^ ty)

  fun run ((bs,v) : exp M) : string =
      pp_bindings_in bs v

  fun runBinds ((bs,_):unit M) : string =
      String.concatWith "\n" (map (pp_binding true) bs)

end
