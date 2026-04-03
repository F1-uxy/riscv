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