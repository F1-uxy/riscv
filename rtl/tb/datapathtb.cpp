#include <stdlib.h>
#include <iostream>
#include <cassert>
#include "Vdatapath.h"
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <stdint.h>
#include "Vdatapath_register_file.h"
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

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vdatapath* datapath = new Vdatapath;

    Vdatapath_register_file* m_regs = datapath->datapath->m_regs;

    Verilated::traceEverOn(true);  // Enable VCD tracing
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    datapath->trace(m_trace, 5);
    m_trace->open("datapath.vcd");

    step(datapath, m_trace, 1);
    step(datapath, m_trace, 2);
    
    CHECK(m_regs->regs[2], 10);

    std::cout << "All tests passed.\n";

    m_trace->close();
    delete datapath;
    delete m_trace;
    return 0;
}
