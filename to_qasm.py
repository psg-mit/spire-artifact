#!/usr/bin/env python3

import pyzx, sys
print(pyzx.Circuit.from_qc(sys.stdin.read()).to_qasm())
