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
$ ./run
Circuit for d = I ** H oo CX oo Z ** Z oo CX oo I ** H:
              .---.
----------*---| Z |---*----------
          |   '---'   |
          |           |
  .---. .-+-. .---. .-+-. .---.
--| H |-| X |-| Z |-| X |-| H |--
  '---' '---' '---' '---' '---'
Semantics of d:
0 1 0 0
1 0 0 0
0 0 0 1
0 0 1 0
Result distribution when evaluating d on |01> :
|00> : 1
|01> : 0
|10> : 0
|11> : 0
...
```

## Relevant Literature

Phillip Kaye, Raymond Laflamme, and Michele Mosca. [An Introduction to Quantum
Computing](https://batistalab.com/classes/v572/Mosca.pdf). Oxford University
Press. 2007.

Wikipedia. Kronecker product. https://en.wikipedia.org/wiki/Kronecker_product

Williams, C.P. (2011). [Quantum
Gates](https://iontrap.umd.edu/wp-content/uploads/2016/01/Quantum-Gates-c2.pdf). In:
Explorations in Quantum Computing. Texts in Computer Science. Springer,
London. https://doi.org/10.1007/978-1-84628-887-6_2.
