#include <stdlib.h>
#include <iostream>
#include <cassert>
#include "Valu.h"
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

void step(Valu* alu, VerilatedVcdC* trace, int cycles = MAX_CYCLES) {
    for (int i = 0; i < cycles; ++i) {
        alu->eval();
        if (trace) trace->dump(sim_time);
        sim_time++;
    }
}

void test_add(Valu* alu, VerilatedVcdC* trace) {
    std::cout << "Running test: 5 + 10\n";
    alu->alucontrol = ALU_ADD;
    alu->rs1 = 0x0005;
    alu->rs2 = 0x000A;
    step(alu, trace);
    CHECK(alu->result, 0x000F);
}

void test_sub(Valu* alu, VerilatedVcdC* trace) {
    std::cout << "Running test: 10 - 5\n";
    alu->alucontrol = ALU_SUB;
    alu->rs1 = 0x000A;
    alu->rs2 = 0x0005;
    step(alu, trace);
    CHECK(alu->result, 0x0005);

    alu->rs1 = 0x0005;
    alu->rs2 = 0x000A;
    step(alu, trace);
    CHECK(alu->result, 0xFFFFFFFB);
}

void test_and(Valu* alu, VerilatedVcdC* trace) {
    std::cout << "Running test: 0xAAAA & 0x5555\n";
    alu->alucontrol = ALU_AND;
    alu->rs1 = 0xAAAA;
    alu->rs2 = 0x5555;
    step(alu, trace);
    CHECK(alu->result, 0x0000);
    CHECK(alu->zero, 1);

    alu->rs1 = 0xAAAA;
    alu->rs2 = 0xAAAA;
    step(alu, trace);
    CHECK(alu->result, 0xAAAA);
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Valu* alu = new Valu;

    Verilated::traceEverOn(true);  // Enable VCD tracing
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    alu->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    test_add(alu, m_trace);
    test_sub(alu, m_trace);
    test_and(alu, m_trace);

    std::cout << "All tests passed.\n";

    m_trace->close();
    delete alu;
    delete m_trace;
    return 0;
}
