#!/bin/bash

MEMORY_LIMIT_KB=32000000
QUESO_TIMEOUT_SEC=3600
set -x
mkdir -p queso_out

run_queso() {
    ( ulimit -v $MEMORY_LIMIT_KB && exec /usr/bin/time -v java --enable-preview -cp queso/SymbolicOptimizer-1.0-SNAPSHOT-jar-with-dependencies.jar Applier -c $1 -g nam -r queso/rules_q3_s6_nam.txt -sr queso/rules_q3_s6_nam_symb.txt -t $QUESO_TIMEOUT_SEC -o queso_out -j "nam" > $2 2>&1 ) || echo 'errored or timed out'
}

for i in {1..2}
do
run_queso circuits/qasm/length_simplified_orig_ccz$i.qasm queso_out/length_simplified_orig$i
done
