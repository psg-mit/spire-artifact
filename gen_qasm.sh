#!/bin/bash

set -x
mkdir -p circuits/qasm

# Convert Toffoli to CCZ by inserting two Hadamard gates
to_ccz() {
    sed -E 's/ccx(.*) q\[(.*)\];/h q[\2];\nccz\1 q[\2];\nh q[\2];/g' $1
}

# feynopt -mctExpand without -O2 only converts MCX to Toffoli without any optimization
for i in {1..10}
do
./feynopt -mctExpand circuits/qc/length_simplified$i.qc | ./to_qasm.py > circuits/qasm/length_simplified$i.qasm
./feynopt -mctExpand circuits/qc/length_simplified_only_cf$i.qc | ./to_qasm.py > circuits/qasm/length_simplified_only_cf$i.qasm
./feynopt -mctExpand circuits/qc/length_simplified_only_cn$i.qc | ./to_qasm.py > circuits/qasm/length_simplified_only_cn$i.qasm
to_ccz circuits/qasm/length_simplified$i.qasm > circuits/qasm/length_simplified_ccz$i.qasm
./feynopt -mctExpand circuits/qc/length$i.qc | ./to_qasm.py > circuits/qasm/length$i.qasm
to_ccz circuits/qasm/length$i.qasm > circuits/qasm/length_ccz$i.qasm
done

for i in {1..10}
do
./feynopt -mctExpand circuits/qc/length_simplified_orig$i.qc | ./to_qasm.py > circuits/qasm/length_simplified_orig$i.qasm
to_ccz circuits/qasm/length_simplified_orig$i.qasm > circuits/qasm/length_simplified_orig_ccz$i.qasm
./feynopt -mctExpand circuits/qc/length_orig$i.qc | ./to_qasm.py > circuits/qasm/length_orig$i.qasm
to_ccz circuits/qasm/length_orig$i.qasm > circuits/qasm/length_orig_ccz$i.qasm
done
