#!/bin/bash

MEMORY_LIMIT_KB=32000000
TIMEOUT_SEC=3600
set -x
mkdir -p feynopt_mctExpand_out

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./feynopt -mctExpand -O2 circuits/qc/length_simplified$i.qc > feynopt_mctExpand_out/length_simplified$i.qc 2> feynopt_mctExpand_out/length_simplified$i.log ) || echo 'errored or timed out'
done

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./feynopt -mctExpand -O2 circuits/qc/length_simplified_only_cf$i.qc > feynopt_mctExpand_out/length_simplified_only_cf$i.qc 2> feynopt_mctExpand_out/length_simplified_only_cf$i.log ) || echo 'errored or timed out'
done

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./feynopt -mctExpand -O2 circuits/qc/length_simplified_only_cn$i.qc > feynopt_mctExpand_out/length_simplified_only_cn$i.qc 2> feynopt_mctExpand_out/length_simplified_only_cn$i.log ) || echo 'errored or timed out'
done

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./feynopt -mctExpand -O2 circuits/qc/length_simplified_orig$i.qc > feynopt_mctExpand_out/length_simplified_orig$i.qc 2> feynopt_mctExpand_out/length_simplified_orig$i.log ) || echo 'errored or timed out'
done

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./feynopt -mctExpand -O2 circuits/qc/length$i.qc > feynopt_mctExpand_out/length$i.qc 2> feynopt_mctExpand_out/length$i.log ) || echo 'errored or timed out'
done

for i in {1..10}
do
( ulimit -v $MEMORY_LIMIT_KB && exec timeout $TIMEOUT_SEC /usr/bin/time -v ./feynopt -mctExpand -O2 circuits/qc/length_orig$i.qc > feynopt_mctExpand_out/length_orig$i.qc 2> feynopt_mctExpand_out/length_orig$i.log ) || echo 'errored or timed out'
done
