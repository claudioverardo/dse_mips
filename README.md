# MIPS pipeline v1.0

VHDL implementation of a MIPS-like architecture.

### Overview

* Schematic: [mips_overview.png](mips_overview.png)
* Instruction Set: [instruction_set.xlsx](instruction_set.xlsx)
* Main file: [src/mips_pipeline.vhdl](src/mips_pipeline.vhdl)

### Features

* RISC pipeline: ID, IF, EX, MEM, WB
* Bit-parallelism: 32 bit
* Address space: 32 bit
* Forwarding Unit
* Data Hazard detection
* Control Hazard detection

### Comments

The project was developed during the course "Digital Systems Electronics" at University of Udine, during the academic year 2019/2020. Analysis and testing were performed with ModelSim PE Student Edition v10.4a.