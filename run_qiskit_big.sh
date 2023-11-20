#!/bin/bash

MEMORY_LIMIT_KB=32000000
set -x
mkdir -p qiskit_out

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec /usr/bin/time -v ./run_qiskit.py circuits/qasm/length_orig$i.qasm > qiskit_out/length_orig$i.qasm 2> qiskit_out/length_orig$i.log ) || echo 'errored or timed out'
done
