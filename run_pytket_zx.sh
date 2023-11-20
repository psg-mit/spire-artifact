#!/bin/bash

MEMORY_LIMIT_KB=32000000
TIMEOUT_SEC=3600
set -x
mkdir -p pytket_zx_out

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./run_pytket_zx.py circuits/qasm/length_simplified_orig$i.qasm > pytket_zx_out/length_simplified_orig$i.qasm 2> pytket_zx_out/length_simplified_orig$i.log ) || echo 'errored or timed out'
done
