#include <stdlib.h>
#include <iostream>
#include <cassert>
#include "Valu_cont.h"
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <stdint.h>

#include "parameters.h"

#define MAX_CYCLES 6
vluint64_t sim_time = 0;

#define CHECK(signal, expected) \
    if ((signal) != (expected)) { \
        std::cerr << "ASSERT FAIL: " #signal " == " << (int)(signal) \
                  << ", expected " << (int)(expected) << std::endl; \
        exit(1); \
    }

void step(Valu_cont* alu_cont, VerilatedVcdC* trace, int cycles = MAX_CYCLES) {
    for (int i = 0; i < cycles; ++i) {
        alu_cont->eval();
        if (trace) trace->dump(sim_time);
        sim_time++;
    }
}

void test_rtype(Valu_cont* alu_cont, VerilatedVcdC* trace) {
    std::cout << "Requesting R-Type ALU ADD signal:\n";

    alu_cont->aluop = ALUOP_RTYPE;
    alu_cont->funct7 = 0;
    alu_cont->funct3 = 0;

    step(alu_cont, trace, 2);
    CHECK(alu_cont->alucontrol, ALU_ADD);


    std::cout << "Requesting R-Type ALU SUB signal:\n";

    alu_cont->aluop = ALUOP_RTYPE;
    alu_cont->funct7 = 32;
    alu_cont->funct3 = 0;

    step(alu_cont, trace, 2);
    CHECK(alu_cont->alucontrol, ALU_SUB);


    std::cout << "Requesting R-Type ALU AND signal:\n";

    alu_cont->aluop = ALUOP_RTYPE;
    alu_cont->funct7 = 0;
    alu_cont->funct3 = 7;

    step(alu_cont, trace, 2);
    CHECK(alu_cont->alucontrol, ALU_AND);


    std::cout << "Requesting R-Type ALU OR signal:\n";

    alu_cont->aluop = ALUOP_RTYPE;
    alu_cont->funct7 = 0;
    alu_cont->funct3 = 6;

    step(alu_cont, trace, 2);
    CHECK(alu_cont->alucontrol, ALU_OR);
}

void test_branch(Valu_cont* alu_cont, VerilatedVcdC* trace) {
    std::cout << "Requesting Branch ALU ADD signal:\n";

    alu_cont->aluop = ALUOP_BRANCH;

    step(alu_cont, trace, 2);
    CHECK(alu_cont->alucontrol, ALU_SUB);
}

void test_lwsw(Valu_cont* alu_cont, VerilatedVcdC* trace) {
    std::cout << "Requesting LWSW ALU ADD signal:\n";

    alu_cont->aluop = ALUOP_LWSW;

    step(alu_cont, trace, 2);
    CHECK(alu_cont->alucontrol, ALU_ADD);
}


int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Valu_cont* alu_cont = new Valu_cont;

    Verilated::traceEverOn(true);  // Enable VCD tracing
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    alu_cont->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    test_rtype(alu_cont, m_trace);
    test_branch(alu_cont, m_trace);
    test_lwsw(alu_cont, m_trace);


    std::cout << "All tests passed.\n";

    m_trace->close();
    delete alu_cont;
    delete m_trace;
    return 0;
}
