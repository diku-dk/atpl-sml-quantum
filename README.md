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

The framework also supports the generation of [Futhark](http://futhark-lang.org)
[5] code for simulating circuits. Futhark is available for most platforms. For
installation details, see [http://futhark-lang.org](http://futhark-lang.org).

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

10. Compare the performance of the Kronecker-free interpreter with the
    performance of the `eval` function.

11. Synthesize a Futhark [5] simulator for a specific quantum circuit and run it
    with different state vectors. You may start by copying the files
    `comp_ex1.sml` and `comp_ex1.mlb` available in the `src` folder. The
    `Makefile` contains code for generating a file `ex1.fut` containing a
    synthesized function for simulating the circuit defined in
    `comp_ex1.sml`. You may generate the file by writing `make ex1.fut`. To load
    the file `ex1.fut` into the Futhark REPL, execute the following commands
    (after having installed [Futhark](http://futhark-lang.org):

	```
	$ make clean ex1.fut
	$ (cd fut; futhark pkg sync)
	$ futhark repl ex1.fut
	[0]> m
	[[(0.0, -0.9999999999999998), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0)],
	 [(0.0, 0.0), (0.0, 0.0), (0.0, 0.9999999999999998), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0)],
	 [(0.0, 0.0), (0.0, -0.9999999999999998), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0)],
	 [(0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.9999999999999998), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0)],
	 [(0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, -0.9999999999999998), (0.0, 0.0), (0.0, 0.0)],
	 [(0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.9999999999999998)],
	 [(0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, -0.9999999999999998), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0)],
	 [(0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.9999999999999998), (0.0, 0.0)]]
	[1]> f (map C.i64 [1,0,0,0,0,0,0,0])
	[(0.0, -0.9999999999999998), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0)]
    ```
	Futhark is available for most
    operating systems, including Linux and macos. More information about Futhark
    is available from [http://futhark-lang.org](http://futhark-lang.org).

## Project Suggestions

1. Implement tooling, based on [4] (but simplified) to find alternative
   (sub-)circuits of degree _n_, for some small _n_.

2. Investigate possibilities for identifying if two qubits are entangled by a
   circuit [8,9].

3. Implement a larger quantum algorithm (e.g., [Grover's
   algorithm](https://en.wikipedia.org/wiki/Grover%27s_algorithm)) of choice
   using the Standard ML framework. You may get inspiration from the [Quantum
   Algorithm Zoo](https://quantumalgorithmzoo.org/).

4. Investigate the possibility for simulating quantum circuits involving only
   the Clifford gates efficiently using compact state representations.

5. Explore the possibility of writing transformations that push `T` gates to the
   end of a circuit and control-gates to the beginning of a circuit.

6. Compare (both practically and theoretically) the state vector simulator
   developed here with the [Qiskit Aer](https://qiskit.github.io/qiskit-aer/)
   state vector simulator [6,7], in particular with respect to run-time
   complexity.

7. Implement a couple of the circuits evaluated in [7] in the framework
   presented here and evaluate their performance.

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

[5] Martin Elsman, Troels Henriksen, and Cosmin Oancea. Parallel Programming in
Futhark. Edition 0.8. Department of Computer Science, University of
Copenhagen. Edition Nov
22, 2023. [latest-pdf](https://readthedocs.org/projects/futhark-book/downloads/pdf/latest/).

[6] Jun Doi and Hiroshi Horii. Cache Blocking Technique to Large Scale Quantum
Computing Simulation on Supercomputers. 2020 IEEE International Conference on
Quantum Computing and Engineering (QCE), Denver, CO, USA, 2020, pp. 212-222,
2020. https://doi.org/10.1109/QCE49297.2020.00035

[7] Jennifer Faj, Ivy Peng, Jacob Wahlgren, Stefano Markidis. Quantum Computer
Simulations at Warp Speed: Assessing the Impact of GPU Acceleration A Case Study
with IBM Qiskit Aer, Nvidia Thrust & cuQuantum. July 2023.
https://doi.org/10.48550/arXiv.2307.14860

[8] Perdrix, S. (2008). Quantum Entanglement Analysis Based on Abstract
Interpretation. In: Alpuente, M., Vidal, G. (eds) Static
Analysis. SAS 2008. Lecture Notes in Computer Science, vol 5079. Springer,
Berlin, Heidelberg. https://doi.org/10.1007/978-3-540-69166-2_18

[9] Nicola Assolini, Alessandra Di Pierro, and Isabella
Mastroeni. 2024. Abstracting Entanglement. In Proceedings of the 10th ACM
SIGPLAN International Workshop on Numerical and Symbolic Abstract Domains (NSAD
'24). Association for Computing Machinery, New York, NY, USA,
34–41. https://doi.org/10.1145/3689609.3689998
