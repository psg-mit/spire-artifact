#!/bin/bash

MEMORY_LIMIT_KB=32000000
TIMEOUT_SEC=3600
set -x
mkdir -p feynopt_toCliffordT_out

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./feynopt -toCliffordT -O2 circuits/qc/length_simplified_orig$i.qc > feynopt_toCliffordT_out/length_simplified_orig$i.qc 2> feynopt_toCliffordT_out/length_simplified_orig$i.log ) || echo 'errored or timed out'
done

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./feynopt -toCliffordT -O2 circuits/qc/length_orig$i.qc > feynopt_toCliffordT_out/length_orig$i.qc 2> feynopt_toCliffordT_out/length_orig$i.log ) || echo 'errored or timed out'
done
