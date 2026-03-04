import random

WIDTH_IN = 12
WIDTH_OUT = 32
NUM_TESTS = 10000
FILENAME = "tests.txt"

with open(FILENAME, "w") as f:
    for _ in range(NUM_TESTS):
        min_val = -(1 << (WIDTH_IN - 1))
        max_val = (1 << (WIDTH_IN - 1)) - 1

        val = random.randint(min_val, max_val)

        val_in = val & ((1 << WIDTH_IN) - 1)
        val_out = val & ((1 << WIDTH_OUT) - 1)

        f.write(f"{val_in:03x} {val_out:06x}\n")

print(f"Generated {NUM_TESTS} tests")
