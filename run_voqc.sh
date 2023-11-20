#!/bin/bash

MEMORY_LIMIT_KB=32000000
TIMEOUT_SEC=3600
set -x
mkdir -p voqc_out

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./run_voqc -f circuits/qasm/length_simplified_orig$i.qasm -o voqc_out/length_simplified_orig$i.qasm > voqc_out/length_simplified_orig$i.log 2>&1 ) || echo 'errored or timed out'
done
