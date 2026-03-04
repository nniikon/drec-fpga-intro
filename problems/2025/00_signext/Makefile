CC        = iverilog
FLAGS     = -g2012 -Wall
TARGET    = signext_sim
TB        = signext_tb.v
SOURCE    = signext_behav.v signext_struct.v
VVP       = vvp
VIEWER    = gtkwave
TEST_FILE = tests.txt

all: run

$(TARGET): $(TB) $(SOURCE)
	$(CC) $(FLAGS) -o $(TARGET) $(TB) $(SOURCE)

$(TEST_FILE):
	python gen_tests.py

run: $(TARGET) $(TEST_FILE)
	$(VVP) $(TARGET)

waves: run
	$(VIEWER) dump.vcd &

clean:
	rm -f $(TARGET) *.vcd tests.txt

.PHONY: all run waves clean