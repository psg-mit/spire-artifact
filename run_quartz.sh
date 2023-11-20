#!/bin/bash

MEMORY_LIMIT_KB=32000000
set -x
mkdir -p quartz_out

for i in {1..5}
do
( ulimit -v $MEMORY_LIMIT_KB && exec /usr/bin/time -v ./run_quartz circuits/qasm/length_simplified_orig_ccz$i.qasm --eqset quartz/3_2_5_complete_ECC_set.json --output quartz_out/length_simplified_orig$i.qasm > quartz_out/length_simplified_orig$i 2>&1 ) || echo 'errored or timed out'
done
