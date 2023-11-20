#!/usr/bin/env python3

from qiskit import QuantumCircuit
from qiskit.compiler import transpile
import sys

circ = QuantumCircuit.from_qasm_file(sys.argv[1])
print("Optimizing...", file=sys.stderr)
circ = transpile(circ, basis_gates=[
                 'h', 'x', 'rz', 'cx'], optimization_level=3)
print("Rz Count After: " + str(circ.count_ops()['rz']), file=sys.stderr)
print(circ.qasm())
