#!/bin/bash

set -x

# Optional: regenerate circuits
# ./gen_circuits.sh
# ./gen_qasm.sh

# Run fast optimizers
./run_feynopt_mctExpand.sh
./run_feynopt_toCliffordT.sh
# ./run_qiskit.sh
# ./run_pytket_zx.sh
# ./run_quizx.sh
# ./run_voqc.sh

# Run timing
./run_timing.sh

# Run slow optimizers
# ./run_pytket_peephole.sh
# ./run_qiskit_big.sh
# ./run_quartz.sh
# ./run_queso.sh
# ./run_timing_big.sh

# Too big to run
# ./run_quizx_big.sh
