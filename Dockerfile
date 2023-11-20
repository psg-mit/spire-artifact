FROM ubuntu:22.04

RUN apt-get update && apt-get install -y time unzip python3 python3-pip opam cabal-install cargo openjdk-17-jre-headless cmake
RUN pip install pytket==1.18.0 qiskit==0.44.1
RUN opam init --disable-sandboxing --compiler=4.13.1 --shell-setup && eval $(opam env) && opam install core core_unix ppx_deriving -y && opam pin add voqc 0.3.0 -y
RUN cabal update && cabal v1-install alex happy

WORKDIR /root
ADD https://github.com/meamy/feynman/archive/cc053850a6bf06ecbf6378cd68c9fcf0c90a308b.zip feynman.zip
RUN unzip feynman.zip && mv feynman-cc053850a6bf06ecbf6378cd68c9fcf0c90a308b feynman
ADD https://github.com/Quantomatic/quizx/archive/5299303c9d64c2e9fec1d49c0248321e2591fa27.zip quizx.zip
RUN unzip quizx.zip && mv quizx-5299303c9d64c2e9fec1d49c0248321e2591fa27 quizx
ADD https://github.com/inQWIRE/mlvoqc/archive/3e6b6222937e949f395fc2f193425d45cad0ad4d.zip mlvoqc.zip
RUN unzip mlvoqc.zip && mv mlvoqc-3e6b6222937e949f395fc2f193425d45cad0ad4d mlvoqc
ADD https://github.com/quantum-compiler/quartz/archive/0c4afdba4bb5637c2a68637d7da2af4784b3b512.zip quartz.zip
RUN unzip quartz.zip && mv quartz-0c4afdba4bb5637c2a68637d7da2af4784b3b512 quartz

WORKDIR /root/feynman
RUN cabal v1-install --bindir=. && cp feynopt /root/feynopt

WORKDIR /root
RUN mkdir queso
WORKDIR /root/queso
ADD SymbolicOptimizer-1.0-SNAPSHOT-jar-with-dependencies.jar ./
# Generate rules
RUN java --enable-preview -cp SymbolicOptimizer-1.0-SNAPSHOT-jar-with-dependencies.jar EnumeratorPrune -g nam -q 3 -s 6

WORKDIR /root/quizx/quizx
# Add frontend runner script
ADD run_quizx.rs src/bin/simp_and_extract.rs
RUN cargo build --release && cp target/release/simp_and_extract /root/run_quizx

WORKDIR /root/mlvoqc
# Add frontend runner script
ADD run_voqc.ml example.ml
RUN eval $(opam env) && make example && cp _build/default/example.exe /root/run_voqc

WORKDIR /root/quartz
# Add frontend runner script
ADD run_quartz.cpp src/test/test_nam.cpp
# Modify CMakeLists.txt to exclude python bindings
RUN sed -i -e '5,31d' -e 's/pybind11::embed//' CMakeLists.txt
# Remove python bindings and simulator from source
RUN rm -r src/quartz/pybind src/quartz/simulator
RUN mkdir build
WORKDIR build
# Generate rules
RUN cmake .. && make gen_ecc_set && ./gen_ecc_set && mv 3_2_5_complete_ECC_set.json ../
RUN make test_nam && cp test_nam /root/run_quartz

WORKDIR /root
ADD tower-src/ ./tower-src/
WORKDIR /root/tower-src
RUN eval $(opam env) && make && cp tower /root

WORKDIR /root
ADD circuits.tar.xz reference_outputs.tar.xz ./
ADD run_feynopt_mctExpand.sh run_feynopt_toCliffordT.sh ./
ADD run_quizx.sh run_quizx_big.sh ./
ADD run_voqc.sh ./
ADD run_quartz.sh ./
ADD run_queso.sh ./
ADD run_pytket_zx.py run_pytket_zx.sh run_pytket_peephole.py run_pytket_peephole.sh ./
ADD run_qiskit.py run_qiskit.sh run_qiskit_big.sh ./
ADD gen_circuits.sh gen_qasm.sh run_timing.sh run_timing_big.sh ./
ADD count_T.py to_qasm.py ./
ADD length_simplified.twr ./
ADD run.sh run_fast.sh ./
