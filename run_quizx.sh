#!/bin/bash

MEMORY_LIMIT_KB=32000000
TIMEOUT_SEC=3600
set -x
mkdir -p quizx_out

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./run_quizx circuits/qasm/length_simplified$i.qasm > quizx_out/length_simplified$i.qasm 2> quizx_out/length_simplified$i.log ) || echo 'errored or timed out'
done

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./run_quizx circuits/qasm/length_simplified_only_cf$i.qasm > quizx_out/length_simplified_only_cf$i.qasm 2> quizx_out/length_simplified_only_cf$i.log ) || echo 'errored or timed out'
done

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec /usr/bin/time -v ./run_quizx circuits/qasm/length_simplified_only_cn$i.qasm > quizx_out/length_simplified_only_cn$i.qasm 2> quizx_out/length_simplified_only_cn$i.log ) || echo 'errored or timed out'
done

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec /usr/bin/time -v ./run_quizx circuits/qasm/length_simplified_orig$i.qasm > quizx_out/length_simplified_orig$i.qasm 2> quizx_out/length_simplified_orig$i.log ) || echo 'errored or timed out'
done
