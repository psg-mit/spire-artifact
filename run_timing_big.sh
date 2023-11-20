#!/bin/bash

TOWER_ROOT=tower-src
MEMORY_LIMIT_KB=32000000
TIMEOUT_SEC=3600
set -x
mkdir -p timing

i=10

for j in {1..5}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./run_quizx circuits/qasm/length_simplified_orig${i}.qasm > timing/quizx_length_simplified_orig${i}_${j}.qasm 2> timing/quizx_length_simplified_orig${i}_${j}.log ) || echo 'errored or timed out'
done
