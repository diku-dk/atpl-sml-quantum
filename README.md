# Quantum Circuits in Standard ML [![CI](https://github.com/diku-dk/atpl-sml-quantum/workflows/CI/badge.svg)](https://github.com/diku-dk/atpl-sml-quantum/actions)

This repository demonstrates the design and development of a simple quantum
circuit simulation framework in Standard ML. The source code is structured to
separate the concerns of specifying and drawing circuits from providing a
semantics and an evaluation framework for the circuits.

## Dependencies

The framework builds with both the [MLKit](https://github.com/melsman/mlkit) and
[MLton](http://mlton.org/) compilers and uses
[`smlpkg`](https://github.com/diku-dk/smlpkg) to fetch relevant libraries,
including [`sml-complex`](https://github.com/diku-dk/sml-complex) and
[`sml-matrix`](https://github.com/diku-dk/sml-matrix), libraries for easily
working with complex numbers and matrices in Standard ML.

On macos, you may install `smlpkg` and `mlkit` using `brew install smlpkg
mlkit`, assuming you have Homebrew installed.

On Linux, you may download binaries from the respective repositories.

## Compiling the Source Code

To compile the source code and run the tests, just execute `make test` in the
source directory. The default is to use `mlkit` as a compiler. If you must use
MLton, execute `MLCOMP=mlton make test` instead.

## Example Run

Here is an example run:
```
$ cd src
$ mlkit quantum_ex1.mlb
...
bash-3.2$ ./run
Circuit for c = (I ** H oo CX oo Z ** Z oo CX oo I ** H) ** I oo I ** SW oo CX ** Y:
              .---.
----------*---| Z |---*-----------------*----
          |   '---'   |                 |
          |           |                 |
  .---. .-+-. .---. .-+-. .---.       .-+-.
--| H |-| X |-| Z |-| X |-| H |-.   .-| X |--
  '---' '---' '---' '---' '---'  \ /  '---'
                                  /
                                 / \  .---.
--------------------------------'   '-| Y |--
                                      '---'
Semantics of c:
~i  0  0  0  0  0  0  0
 0  0  i  0  0  0  0  0
 0 ~i  0  0  0  0  0  0
 0  0  0  i  0  0  0  0
 0  0  0  0  0 ~i  0  0
 0  0  0  0  0  0  0  i
 0  0  0  0 ~i  0  0  0
 0  0  0  0  0  0  i  0
Result distribution when evaluating c on |101> :
|000> : 0
|001> : 0
|010> : 0
|011> : 0
|100> : 1
|101> : 0
|110> : 0
|111> : 0
```

## Exercises

1. Install MLKit or MLton and arrange for the tests to run.

2. Adjust the setting in `diagram.sml` to make the diagrams show in compact
   mode.

3. Write your first circuit of choice by modifying the `quantum_ex1.sml` file
   (create new files `quantum_ex2.sml` and `quantum_ex2.mlb`). Restrict yourself
   to a circuit that uses Pauli gates, the Hadamard gate, controlled gates, and
   swaps.

4. Add the possibility for working with `T` gates. You need to adjust code both
   in the `circuit.sml` and in the `semantics.sml` source files. Notice that
   after adding a constructor to the `datatype` definition in `circuit.sml`, the
   respective compiler will tell you where there are non-exhaustive matches.

5. An advantage of working with first-class circuits is that you may write functions
   that generate circuits. Write a recursive function for swapping qubit 0 with
   qubit _n_. The function `swap` should take two integers as arguments and return
   a circuit (of type `t`). The first integer argument should specify the height
   of the circuit (i.e., the number of qubits) and the second argument should
   specify the value _n_. The function may make use of the following auxiliary
   function `id` that takes an integer _n_ as argument and creates a circuit
   consisting of _n_ "parallel" `I`-gates (i.e., _n_ `I`-gates composed using the
   tensor-combinator `**`.

   ```
   fun id 1 = I
     | id n = I ** id (n-1)
   ```

   The result of `swap 4 2` should result in the circuit `SW ** I ** I oo I **
   SW ** I`.

   Hint: first write a function `swap1` that also takes two argument integers
   _k_ and _n_ and returns a one-layer circuit of height _k_ that swaps qubit
   _n_ and _n-1_.

   Add the functionality to the `CIRCUIT` signature and to the
   `Circuit`structure and demonstrate the functionality.

6. The `draw` functionality currently does not cover controlled control-gates
   (e.g., the Toffoli gate), whereas the `sem` functionality does. Extend the
   structure `Diagram` with a function for drawing a single-qubit gate
   (specified by a string) with _n_ initial control-gates (where _n_ is a
   function argument. Add the functionality to the `DIAGRAM` signature and the
   `Diagram` structure and extend the `Circuit.draw` function to draw controlled
   control-gates using the new functionality.

7. Write an "optimiser" that takes a circuit and replaces it with an "optimised"
   circuit with the same or fewer gates. For instance, incorporate the identity
   `I = H oo H`. Maybe use the identity _A_ `**` _B_ `oo` _D_ ** _E_ = (_A_
   `oo` _D_) ** (_B_ `oo` _E_), given appropriate dimension restrictions and associativity of `**`, to
   make your optimiser recognise more opportunities.

8. Write a recursive function `inverse` that takes a circuit and returns the
   inversed circuit using the property `inverse` (_A_ `oo` _B_) = (`inverse`
   _B_) `oo` (`inverse` _A_), for any "unitary" _A_ and _B_. Notice that only
   some of the basic gates have the property that they are their own inverse
   (e.g., Y and H) . For others, such as the T gate, this property does not
   hold, which can be dealt with by extending the circuit data type to contain a
   TI gate (an inverse T-gate defined as the conjugated transpose of the T-gate).

9. Investigate how large circuits (in terms of the number of qubits) you may
   simulate in less than 10 seconds on a standard computer.

## Project Suggestions

1. Implement tooling, based on [4] (but simplified) to find alternative
   (sub-)circuits of degree _n_, for some small _n_.

2. Investigate possibilities for identifying if two qubits are entangled by a
   circuit.

3. Implement a larger quantum algorithm of choice using the Standard ML
   framework.

4. Explore the possibility of using alternative (nested) matrix representations
   for specifying the semantics of circuits. Currently, tensor products are
   expanded eagerly, although using pull-arrays, but sparsity and algebraic
   properties are not exploited.

## Literature

[1] Phillip Kaye, Raymond Laflamme, and Michele Mosca. [An Introduction to
Quantum Computing](https://batistalab.com/classes/v572/Mosca.pdf). Oxford
University Press. 2007.

[2] Wikipedia. Kronecker product. https://en.wikipedia.org/wiki/Kronecker_product

[3] Williams, C.P. (2011). [Quantum
Gates](https://iontrap.umd.edu/wp-content/uploads/2016/01/Quantum-Gates-c2.pdf). In:
Explorations in Quantum Computing. Texts in Computer Science. Springer,
London. https://doi.org/10.1007/978-1-84628-887-6_2.

[4] Jessica Pointing, Oded Padon, Zhihao Jia, Henry Ma, Auguste Hirth, Jens
Palsberg and Alex Aiken. [Quanto: optimizing quantum circuits with automatic
generation of circuit
identities](https://iopscience.iop.org/article/10.1088/2058-9565/ad5b16/pdf). Quantum
Science and Technology, Volume 9, Number 4. July 2024. Published by IOP
Publishing Ltd. https://doi.org/10.1088/2058-9565/ad5b16.
