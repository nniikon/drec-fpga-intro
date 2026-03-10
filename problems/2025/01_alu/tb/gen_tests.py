import random

INSTRUCTIONS = {
    #   (name:  funct7, funct3)
    "ADD": (0x00, 0x0),
    "SUB": (0x20, 0x0),
    "SLL": (0x00, 0x1),
    "SLT": (0x00, 0x2),
    "SLTU": (0x00, 0x3),
    "XOR": (0x00, 0x4),
    "SRL": (0x00, 0x5),
    "SRA": (0x20, 0x5),
    "OR": (0x00, 0x6),
    "AND": (0x00, 0x7),
}


def to_signed_32(val):
    return val if val < 0x80000000 else val - 0x100000000


def compute_expected(inst, rs1, rs2):
    shamt = rs2 & 0x1F

    if inst == "ADD":
        res = rs1 + rs2
    elif inst == "SUB":
        res = rs1 - rs2
    elif inst == "SLL":
        res = rs1 << shamt
    elif inst == "SLT":
        res = 1 if to_signed_32(rs1) < to_signed_32(rs2) else 0
    elif inst == "SLTU":
        res = 1 if rs1 < rs2 else 0
    elif inst == "XOR":
        res = rs1 ^ rs2
    elif inst == "SRL":
        res = rs1 >> shamt
    elif inst == "SRA":
        res = to_signed_32(rs1) >> shamt
    elif inst == "OR":
        res = rs1 | rs2
    elif inst == "AND":
        res = rs1 & rs2
    else:
        res = 0

    return res & 0xFFFFFFFF


def generate_tests(filename="tests.txt", num_tests_per_inst=20):
    with open(filename, "w") as f:
        for inst, (funct7, funct3) in INSTRUCTIONS.items():
            for _ in range(num_tests_per_inst):
                rs1 = random.randint(0, 0xFFFFFFFF)
                rs2 = random.randint(0, 0xFFFFFFFF)

                expected_rd = compute_expected(inst, rs1, rs2)
                expected_exception = 0

                line = f"{funct7:02x} {funct3:01x} {rs1:08x} {rs2:08x} {expected_rd:08x} {expected_exception:01x}\n"
                f.write(line)


if __name__ == "__main__":
    generate_tests()
