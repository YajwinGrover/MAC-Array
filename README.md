# MAC (Multiply-Accumulate) Array

A parallel, pipelined multiply-accumulate array implemented in Verilog — the core datapath building block behind hardware accelerators used in AI/ML inference hardware.

## Overview

This project implements a MAC array capable of performing parallel multiply-accumulate operations on 64-bit vectors, achieving ~10ns throughput per computation through a pipelined datapath. The architecture is designed to be extendible to higher bit-count vectors.

## Design Highlights

- **Parallel MAC datapath** — multiple multiply-accumulate units operate in parallel rather than sequentially, trading area for throughput.
- **Pipelined, chained architecture** — data flows through chained pipeline stages between submodules, allowing a new computation to begin each cycle rather than waiting for multiple cycles for a single chunk of data to finish computation.
- **~10ns throughput per computation** — on 64-bit vectors, once the pipeline is full, a new result is produced roughly every 10ns. Thus streaming data can happen on every positive clock edge, leaving no downtime. 
- **Extendible bit-width** — the architecture was designed so that scaling to wider vectors is a matter of extending the datapath rather than restructuring the design.
- **Reference-model verification** — outputs were checked against a golden reference model rather than by inspection alone, to catch correctness issues that only show up on specific input patterns.


## Verification

- Submodule-level simulation to verify individual MAC units in isolation
- Full-array simulation compared against a software reference model
- Tested against various type of inputs (zeros, negatives, overflows) to check for all edge cases.

## Tools

- Verilog (RTL)
- Vivado (synthesis, simulation)

1. Open the project in Vivado ([version])
2. Run the testbench(es) under `sim/` — results are compared automatically against the reference model
3. [Add: any specific instructions for regenerating test vectors or reference outputs]
