CC        = iverilog
FLAGS     = -g2012 -Wall
TARGET    = alu_sim
TB        = tb/alu_tb.v
SOURCE    = source/alu.v
VVP       = vvp
VIEWER    = gtkwave
TEST_FILE = tests.txt

all: run

$(TARGET): $(TB) $(SOURCE)
	$(CC) $(FLAGS) -o $(TARGET) $(TB) $(SOURCE)

$(TEST_FILE):
	python tb/gen_tests.py

run: $(TARGET) $(TEST_FILE)
	$(VVP) $(TARGET)

waves: run
	$(VIEWER) dump.vcd &

clean:
	rm -f $(TARGET) *.vcd $(TEST_FILE)

.PHONY: all run waves clean