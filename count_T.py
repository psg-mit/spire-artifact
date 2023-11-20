#!/usr/bin/env python3

import fileinput

count = 0
T_PER_TOFFOLI = 7

TOFFOLI_GATES = {"tof", "ccx", "ccz"}
T_GATES = {"t", "tdg", "t*",
           # Used by QuiZX
           "rz(0.25*pi)", "rz(-0.25*pi)", "rz(0.75*pi)", "rz(-0.75*pi)",
           # Used by Qiskit
           # Note: Qiskit produces floating points such as 0.2961504522271827.
           # In these cases, we report an undercount of Qiskit's T-complexity.
           "rz(pi/4)", "rz(-pi/4)",
           # Used by VOQC
           "rzq(1,4)", "rzq(3,4)", "rzq(5,4)", "rzq(7,4)",
           # Used by Pytket
           # Note: Pytket produces floating points such as 3.914666934476273*pi.
           # In these cases, we report an undercount of Pytket's T-complexity.
           "rz(1.25*pi)", "rz(1.75*pi)",
           "rz(2.25*pi)", "rz(2.75*pi)",
           "rz(3.25*pi)", "rz(3.75*pi)",
           # Used by QUESO
           # Note: QUESO produces floating points that are a mix of multiples of
           # pi/2 and pi/4.
           "rz(pi/4.0)", "rz(-pi/4.0)",
           "rz(-0.7853981633974483)", "rz(0.7853981633974483)"}

for line in fileinput.input():
    try:
        gate = line.split(maxsplit=1)[0].lower()
        if gate in TOFFOLI_GATES:
            c = line.count(" ")
            if c >= 3:
                count += ((c - 3) * 2 + 1) * T_PER_TOFFOLI
        elif gate in T_GATES:
            count += 1
    except IndexError:
        pass
print(count)
