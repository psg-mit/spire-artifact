#!/usr/bin/env python3

from pytket import OpType
from pytket.qasm import circuit_from_qasm, circuit_to_qasm_str
from pytket.passes import FullPeepholeOptimise, RemoveRedundancies, SequencePass
from pytket.transform import Transform
from pytket.utils.stats import gate_counts
import sys

c = circuit_from_qasm(sys.argv[1])
print("Starting peephole optimization", file=sys.stderr)
SequencePass([FullPeepholeOptimise(), RemoveRedundancies()]).apply(c)
print("Finished peephole optimization", file=sys.stderr)
Transform.RebaseToPyZX().apply(c)
print("Rz Count After: " + str(gate_counts(c)[OpType.Rz]), file=sys.stderr)
print(circuit_to_qasm_str(c))
