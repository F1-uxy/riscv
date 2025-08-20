## Risc-V CPU Implmented in SystemVerilog

### Instruction Format:
There are 6 formats of instruction:
<ol>
    <li> Register-Register (R-type)
    <li> Immediate (I-type)
    <li> Store (S-type)
    <li> Branch (SB-type)
    <li> Unconditional Jump (UJ-type)
    <li> Upper Immediate (UI-type)
</ol>


#### R-type (Register-Register Arithmetic Instructions)

| Field    | Bits   | Description                        |
|----------|--------|----------------------------------|
| funct7   | 7 bits | Additional opcode/function field  |
| rs2      | 5 bits | Second source register operand    |
| rs1      | 5 bits | First source register operand     |
| funct3   | 3 bits | Additional opcode/function field  |
| rd       | 5 bits | Destination register (result)     |
| opcode   | 7 bits | Basic opcode of the instruction   |

---

#### I-type (Immediate and Load Instructions)

| Field      | Bits    | Description                        |
|------------|---------|----------------------------------|
| immediate  | 12 bits | Two’s complement immediate value |
| rs1        | 5 bits  | Source register operand           |
| funct3     | 3 bits  | Additional opcode/function field  |
| rd         | 5 bits  | Destination register (result)     |
| opcode     | 7 bits  | Basic opcode of the instruction   |

---

#### S-type (Store Instructions)

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

#### SB-type (Conditional Branch Instructions)

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

### Control Lines:
<ul>
    <li> Register File Write Enable
    <li> Instruction Type [2:0]
    <li> Data Memory Unit Write Enable
    <li> Data Memory Unit Read Enable
    <li> Memory to Register Selector
    <li> Alu Source Selector
    <li> Program Counter Source Selector
</ul>


| Instruction | reg\_we | alu\_src | dmu\_we | dmu\_re | mtreg | branch | instr\_type |
| ----------- | ------- | -------- | ------- | ------- | ----- | ------ | ----------- |
| R-type      | 1       | 0        | 0       | 0       | 0     | 0      | R\_TYPE     |
| I-type      | 1       | 1        | 0       | 0       | 0     | 0      | I\_TYPE     |
| LW          | 1       | 1        | 0       | 1       | 1     | 0      | I\_TYPE     |
| SW          | 0       | 1        | 1       | 0       | 0     | 0      | S\_TYPE     |
| BEQ         | 0       | 0        | 0       | 0       | 0     | 1      | SB\_TYPE    |
| LUI         | 1       | 1        | 0       | 0       | 0     | 0      |             |


### Pipelining:
<ol>
    <li> IF: Fetch instruction from memory
    <li> ID: Read registers and decode the instruction
    <li> EX: Execute the operation or calculate an address
    <li> MEM: Access an operand in data memory (optional)
    <li> WB: Write the result back into a register (optional)
</ol>

Write occurs in the first half of a clock cycle \& read occurs in the second half

#### Instructions:
| Instruction           | Fetch | Register Read | ALU operation | Data Access | Register Write |
| --------------------- | ----- | ------------- | ------------- | ----------- | -------------- |
| Load Doubleword (ld)  | X     | X             | X             | X           | X              |
| Store Doubleword (sd) | X     | X             | X             | X           |                |
| R-Format              | X     | X             | X             |             | X              |
| Branch                | X     | X             | X             |             |                |

#### Pipeline Register:
Registers are need to hold inter-stage values for a successful pipeline:
<ul>
    <li> IF/ID  - 92b wide  (32b Instruction + 64b PC Address)
    <li> ID/EX  - 389b wide (5b Register Select + 64b Data 1 + 64b Data 2 + 64b Immediate Value + 64b PC Address + 64b Rs1 + 64b Rs2)
    <li> EX/MEM - 198b wide (5b Register Select + 64b PC Address + 64b ALU Result + 64b Data 2 + 1b Zero Flag)
    <li> MEM/WB - 133b wide (5b Register Select + 64b ALU result + 64b Data read)
</ul>

##### IF/ID Register:
| Field       | Bits  | Description           |
| ----------- | ----- | --------------------- |
| PC          | 91:32 | Program Counter value |
| Instruction | 31:0  | Current instruction   |


##### ID/EX Register:
| Field      | Bits    | Description                      |
| ---------- | ------- | -------------------------------- |
| Rs1        | 270:266 | Input register select 1          |
| Rs2        | 265:261 | Input register select 2          |
| Reg Select | 260:256 | Output register select           |
| PC         | 255:192 | Program Counter value            |
| Data 1     | 191:128 | Register Data 1 port             |
| Data 2     | 127:64  | Register Data 2 port             |
| Immediate  | 63:0    | Immediate Generation Unit output |

##### EX/MEM Register:
| Field      | Bits    | Description               |
| ---------- | ------- | ------------------------- |
| Reg Select | 197:193 | Register Select           |
| PC         | 192:129 | Program Counter sum value |
| Zero Flag  | 128     | Zero Flag                 |
| Alu Result | 127:64  | Alu result                |
| Data 2     | 63:0    | Register Data 2 Port      |

##### MEM/WB Register:
| Field      | Bits    | Description        |
| ---------- | ------- | ------------------ |
| Reg Select | 132:128 | Register Select    |
| Read Data  | 127:64  | DMU read data      |
| Address    | 63:0    | Alu address result |

#### Forwarding
Forwarding is done by the forwarding unit to forward values through the pipeline registers.

| Control        | Source | Description                                                                   |
| -------------- | ------ | ----------------------------------------------------------------------------- |
| forward_a = 00 | ID/EX  | The first ALU operand comes from the register file                            |
| forward_a = 10 | EX/MEM | The first ALU operand is forwarded from the prior ALU result                  |
| forward_a = 01 | MEM/WB | The first ALU operand is forwarded from data memory or an earlier ALU result  |
| forward_b = 00 | ID/EX  | The second ALU operand comes from the register file                           |
| forward_b = 10 | EX/MEM | The second ALU operand is forwarded from the prior ALU result                 |
| forward_b = 01 | MEM/WB | The second ALU operand is forwarded from data memory or an earlier ALU result |


#### Branching:
For a pipelined branch we always assume that the branch is not taken. If the branch is taken then we are penalized with a stall

For a less wasteful branching mechanism we move the branch adder from the EX stage to the ID stage to reduce the cost of a branch taken. This does add extra forwarding and hazard detection logic as we much check the rest of the pipeline for any results related to the branch instruction.

#### Useful Websites:
https://luplab.gitlab.io/rvcodecjs/

https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html

https://www.itsembedded.com/dhd/verilator_1/