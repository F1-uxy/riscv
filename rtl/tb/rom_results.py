non_conflict = {
    1: 0,
    2: 5,
    3: 10,
    4: 4,
    5: -10,
    6: 10
}

testbench = {
    1: 10,
    2: 3,
    3: 13,
    4: 7,
    5: 2,
    6: 11,
    7: 2,
    8: 11,
    9: 10,
    10: 0,
    11: 123
}

conflict = {
    1: 5,     
    2: 8,     
    3: 10,
    4: 5,
    5: 5,
    6: 5,
    7: 0,
    8: 0,
    9: 123,
}

bpu = {
    1: 0,
    10: 99
}

alu = {
    1: -5,
    2: 3,
    3: -8,
    4: 1,
    5: 0,
    6: 24,
    7: 0x1FFFFFFFFFFFFFFF,
    8: -1
}

loadstore = {
    1: -1,
    2: 0x7FFF,
    3: -2147483648,
    10: -1,
    11: 255,
    12: -1,
    13: 65535,
    14: 32767,
    15: 32767,
    16: -2147483648,
    17: 2147483648,
    18: 0x12345000,
    19: 0x1234504c
}

jump = {
    0: 0,
    1: 5,
    2: 0x0C,
    3: 0,
    4: 42,
    5: 0x1C,
    6: 0x24,
    7: 0,
    8: 77,
}

sandbox = {
    0: 0
}

def load_mem(dut, path, depth=256):
    for i in range(depth):
        dut.m_imem.mem.value[i] = 0

    with open(path, "r") as f:
        idx = 0
        for line in f:
            line = line.split("//")[0].strip()

            if not line:
                continue
            value = int(line, 16)
            dut.m_imem.mem.value[idx] = value
            idx += 1