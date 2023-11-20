#!/bin/bash

TOWER_ROOT=tower-src
MEMORY_LIMIT_KB=32000000
TIMEOUT_SEC=3600
set -x
mkdir -p timing

i=10

for j in {1..5}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./tower -c --optimize_lir --dotQC --timing -b length:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/length.twr > timing/length${i}_${j}.qc 2> timing/tower_length${i}_${j}.log ) || echo 'errored or timed out'
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./tower -c --dotQC --timing -b length:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/length.twr > timing/length_orig${i}_${j}.qc 2> timing/tower_length_orig${i}_${j}.log ) || echo 'errored or timed out'
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./tower -c --optimize_lir --dotQC --timing -b length:$i $TOWER_ROOT/tests/list.twr length_simplified.twr > timing/length_simplified${i}_${j}.qc 2> timing/tower_length_simplified${i}_${j}.log ) || echo 'errored or timed out'
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./tower -c --dotQC --timing -b length:$i $TOWER_ROOT/tests/list.twr length_simplified.twr > timing/length_simplified_orig${i}_${j}.qc 2> timing/tower_length_simplified_orig${i}_${j}.log ) || echo 'errored or timed out'
done

for j in {1..5}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./feynopt -mctExpand -O2 circuits/qc/length_simplified${i}.qc > timing/feynopt_length_simplified${i}_${j}.qc 2> timing/feynopt_length_simplified${i}_${j}.log ) || echo 'errored or timed out'
done

for j in {1..5}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./feynopt -mctExpand -O2 circuits/qc/length_simplified_orig${i}.qc > timing/feynopt_length_simplified_orig${i}_${j}.qc 2> timing/feynopt_length_simplified_orig${i}_${j}.log ) || echo 'errored or timed out'
done

for j in {1..5}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./run_quizx circuits/qasm/length_simplified${i}.qasm > timing/quizx_length_simplified${i}_${j}.qasm 2> timing/quizx_length_simplified${i}_${j}.log ) || echo 'errored or timed out'
done

for j in {1..5}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./feynopt -mctExpand -O2 circuits/qc/length${i}.qc > timing/feynopt_length${i}_${j}.qc 2> timing/feynopt_length${i}_${j}.log ) || echo 'errored or timed out'
done

for j in {1..5}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./feynopt -mctExpand -O2 circuits/qc/length_orig${i}.qc > timing/feynopt_length_orig${i}_${j}.qc 2> timing/feynopt_length_orig${i}_${j}.log ) || echo 'errored or timed out'
done
