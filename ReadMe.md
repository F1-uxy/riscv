### Risc-V CPU Implmented in SystemVerilog

#### Instruction Format:
There are 6 formats of instruction:
<ol>
    <li> Register-Register (R-type)
    <li> Immediate (I-type)
    <li> Store (S-type)
    <li> Branch (SB-type)
    <li> Unconditional Jump (UJ-type)
    <li> Upper Immediate (UI-type)
</ol>

### R-type (Register-Register Arithmetic Instructions)

| Field    | Bits   | Description                        |
|----------|--------|----------------------------------|
| funct7   | 7 bits | Additional opcode/function field  |
| rs2      | 5 bits | Second source register operand    |
| rs1      | 5 bits | First source register operand     |
| funct3   | 3 bits | Additional opcode/function field  |
| rd       | 5 bits | Destination register (result)     |
| opcode   | 7 bits | Basic opcode of the instruction   |

---

### I-type (Immediate and Load Instructions)

| Field      | Bits    | Description                        |
|------------|---------|----------------------------------|
| immediate  | 12 bits | Two’s complement immediate value |
| rs1        | 5 bits  | Source register operand           |
| funct3     | 3 bits  | Additional opcode/function field  |
| rd         | 5 bits  | Destination register (result)     |
| opcode     | 7 bits  | Basic opcode of the instruction   |

---

### S-type (Store Instructions)

| Field            | Bits     | Description                         |
|------------------|----------|-----------------------------------|
| immediate[11:5]   | 7 bits   | Upper part of 12-bit immediate     |
| rs2              | 5 bits   | Source register (value to store)   |
| rs1              | 5 bits   | Base address register              |
| funct3           | 3 bits   | Additional opcode/function field   |
| immediate[4:0]    | 5 bits   | Lower part of 12-bit immediate     |
| opcode           | 7 bits   | Basic opcode of the instruction    |

> Note: The 12-bit immediate in S-type is split between two fields (`imm[11:5]` and `imm[4:0]`) and combined during decoding.

---

### SB-type (Conditional Branch Instructions)

| Field            | Bits            | Description                          |
|------------------|-----------------|------------------------------------|
| immediate[12]    | 1 bit (bit 31)   | Sign bit of the immediate           |
| immediate[10:5]  | 6 bits (bits 30-25) | Upper immediate bits             |
| rs2              | 5 bits (bits 24-20) | Second source register           |
| rs1              | 5 bits (bits 19-15) | First source register            |
| funct3           | 3 bits (bits 14-12) | Branch condition code           |
| immediate[4:1]   | 4 bits (bits 11-8)  | Middle immediate bits            |
| immediate[11]    | 1 bit (bit 7)    | Bit 11 of immediate                |
| opcode           | 7 bits (bits 6-0) | Basic opcode of the instruction   |

> Note: The 12-bit immediate in SB-type is assembled from several fields and then shifted left by 

The rs2 and rs1 values are always in the same location for hardware simplicity therefore, the immediate value must be split into 2 parts.

Page 509