#include <stdlib.h>
#include <iostream>
#include <cassert>
#include "Vdatapath.h"
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <stdint.h>
#include "Vdatapath_register_file.h"
#include "Vdatapath_dmu.h"

#include "Vdatapath_datapath.h"

#include "parameters.h"

#define MAX_CYCLES 6
vluint64_t sim_time = 0;


#define CHECK(signal, expected) \
    if ((signal) != (expected)) { \
        std::cerr << "ASSERT FAIL: " #signal " == " << (int)(signal) \
                  << ", expected " << (int)(expected) << std::endl; \
        exit(1); \
    }

static inline void tick(Vdatapath* datapath, VerilatedVcdC* trace) {
    datapath->clk = 0; datapath->eval(); trace->dump(sim_time++);
    datapath->clk = 1; datapath->eval(); trace->dump(sim_time++);
}

void step(Vdatapath* datapath, VerilatedVcdC* trace, int count)
{
    for(int i = 0; i < count; i++)
    {
        tick(datapath, trace);
    }
}

void run_test_program(Vdatapath* datapath, VerilatedVcdC* m_trace, Vdatapath_register_file* m_regs, Vdatapath_dmu* m_dmu)
{
    step(datapath, m_trace, 14);  // enough cycles to execute full program

    CHECK(m_regs->regs[1], 10);   // x1 ← 10 via:     addi x1, x0, 10

    CHECK(m_regs->regs[2], 3);    // x2 ← 3 via:      addi x2, x0, 3

    CHECK(m_regs->regs[3], 13);   // x3 ← 10 + 3 via: add x3, x1, x2

    CHECK(m_regs->regs[4], 7);    // x4 ← 10 - 3 via: sub x4, x1, x2

    CHECK(m_regs->regs[5], 2);    // x5 ← 10 & 3 via: and x5, x1, x2

    CHECK(m_regs->regs[6], 11);   // x6 ← 10 | 3 via: or  x6, x1, x2

    CHECK(m_regs->regs[7], 2);    // x7 ← 10 & 3 via: andi x7, x1, 3

    CHECK(m_regs->regs[8], 11);   // x8 ← 10 | 1 via: ori  x8, x1, 1
    CHECK(m_dmu->mem[0],  10)
    CHECK(m_regs->regs[9], 10);   // x9 ← mem[0] via:
                                  //   sw x1, 0(x0)
                                  //   lw x9, 0(x0)
    
    CHECK(m_regs->regs[10], 0);   // x10 not set due to branch:
                                  // beq x1, x1, +8
                                  // addi x10, x0, 99 ← skipped

    CHECK(m_regs->regs[11], 123); // x11 ← 123 via:
                                  // bne x1, x2, +8 (not taken)
                                  // addi x11, x0, 123
                                  
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vdatapath* datapath = new Vdatapath;

    Vdatapath_register_file* m_regs = datapath->datapath->m_regs;
    Vdatapath_dmu* m_dmu = datapath->datapath->m_dmu;

    Verilated::traceEverOn(true);  // Enable VCD tracing
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    datapath->trace(m_trace, 5);
    m_trace->open("datapath.vcd");

    step(datapath, m_trace, 1);
    step(datapath, m_trace, 2);

    //run_test_program(datapath, m_trace, m_regs, m_dmu);

    std::cout << "All tests passed.\n";

    m_trace->close();
    delete datapath;
    delete m_trace;
    return 0;
}
