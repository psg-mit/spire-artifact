#!/bin/bash

MEMORY_LIMIT_KB=32000000
set -x
mkdir -p quizx_out

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec /usr/bin/time -v ./run_quizx circuits/qasm/length$i.qasm > quizx_out/length$i.qasm 2> quizx_out/length$i.log ) || echo 'errored or timed out'
done

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec /usr/bin/time -v ./run_quizx circuits/qasm/length_orig$i.qasm > quizx_out/length_orig$i.qasm 2> quizx_out/length_orig$i.log ) || echo 'errored or timed out'
done
