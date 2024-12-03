module type MAT = {
  type t
  val tensor [m][n][p][q] : [m][n]t -> [p][q]t -> [m*p][n*q]t
  val control         [m] : [m][m]t -> [2*m][2*m]t
  val matmul    [m][n][k] : [m][n]t -> [n][k]t -> [m][k]t
  val matvecmul    [m][n] : [m][n]t -> [n]t -> [m]t
  val vec          [m][n] : [m][n]t -> [n*m]t
  val unvec        [m][n] : [n*m]t -> [m][n]t
}

-- [vec a] stacks all columns of a to form a vector.
--
-- [unvec v] unstacks columns to form a matrix. We have unvec(vec V) = V.
--
-- [control a] constructs the direct sum matrix with I and a.


module type NUM = {
  type t
  val i64 : i64 -> t
  val *   : t -> t -> t
  val +   : t -> t -> t
}

module mk_mat(T:NUM) : MAT with t = T.t = {
  type t = T.t

  def scale [m][n] (s:t) (a:[m][n]t) : [m][n]t =
    map (map (T.((s*)))) a

  def tensor [m][n][p][q] (a:[m][n]t) (b:[p][q]t) : [m*p][n*q]t =
    map (map (\s -> scale s b)) a
    |> map transpose |> flatten |> map flatten

  def control [m] (a:[m][m]t) : [2*m][2*m]t =
    tabulate_2d (2*m) (2*m) (\i j -> if i >= m && j >= m then a[i-m][j-m]
				     else if i == j then T.i64 1 else T.i64 0)

  def matmul [m][n][k] (a:[m][n]t) (b:[n][k]t) : [m][k]t =
    map (\ar ->
           map (\bc ->
                  reduce (T.+) (T.i64 0) (map2 (T.*) ar bc))
               (transpose b))
	a

  def matvecmul [m][n] (a:[m][n]t) (v:[n]t) : [m]t =
    map (\ar ->
           reduce (T.+) (T.i64 0) (map2 (T.*) ar v)
	) a

  def vec [m][n] (a:[m][n]t) : [n*m]t =
    transpose a |> flatten

  def unvec [n][m] (a:[n*m]t) : [m][n]t =
    unflatten a |> transpose
}

module mat = mk_mat(f64)

-- tests: see https://en.wikipedia.org/wiki/Kronecker_product
def test0 =
  let a : [2][2]f64 = [[1,2],[3,4]]
  let b : [2][2]f64 = [[0,5],[6,7]]
  in mat.tensor a b

def test1 =
  let c : [2][3]f64 = [[1,-4,7],[-2,3,3]]
  let d : [4][4]f64 = [[8,-9,-6,5],[1,-3,-4,7],[2,8,-8,-3],[1,2,-5,-1]]
  in mat.tensor c d

def test2 =
  let x : [2][2]f64 = [[0,1],[1,0]]
  in mat.control x

def test3 =
  let a : [2][3]f64 = [[1,2,3],[4,5,6]]
  in mat.vec a -- expect [1,4,2,5,3,6]

def test4 =
  let a = flatten [[1,4],[2,5],[3,6]]
  in mat.unvec a -- expect [[1,2,3],[4,5,6]]
