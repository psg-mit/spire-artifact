#!/bin/bash

MEMORY_LIMIT_KB=32000000
set -x
mkdir -p pytket_peephole_out

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec /usr/bin/time -v ./run_pytket_peephole.py circuits/qasm/length_simplified_orig$i.qasm > pytket_peephole_out/length_simplified_orig$i.qasm 2> pytket_peephole_out/length_simplified_orig$i.log ) || echo 'errored or timed out'
done
