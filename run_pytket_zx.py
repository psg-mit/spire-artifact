#!/usr/bin/env python3

from pytket import OpType
from pytket.qasm import circuit_from_qasm, circuit_to_qasm_str
from pytket.passes import auto_rebase_pass, ZXGraphlikeOptimisation, SequencePass, RemoveRedundancies
from pytket.transform import Transform
from pytket.utils.stats import gate_counts
import sys

c = circuit_from_qasm(sys.argv[1])
# Pytket requires that we lower to the Clifford+T gate set before ZXGraphlikeOptimisation
auto_rebase_pass({OpType.Rx, OpType.Rz, OpType.X, OpType.Z,
                 OpType.H, OpType.CZ, OpType.CX}).apply(c)
print("Rz Count Before: " + str(gate_counts(c)[OpType.Rz]), file=sys.stderr)
print("Starting ZX optimization", file=sys.stderr)
while True:
    try:
        SequencePass([ZXGraphlikeOptimisation(),
                     RemoveRedundancies()]).apply(c)
        break
    except RuntimeError as e:
        # ZXGraphlikeOptimisation throws a RuntimeError nondeterministically
        print("Got RuntimeError, trying again", file=sys.stderr)
        print(e, file=sys.stderr)
        continue
print("Finished ZX optimization", file=sys.stderr)
Transform.RebaseToPyZX().apply(c)
print("Rz Count After: " + str(gate_counts(c)[OpType.Rz]), file=sys.stderr)
print(circuit_to_qasm_str(c))
