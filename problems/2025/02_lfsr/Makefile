CC        = iverilog
FLAGS     = -g2012 -Wall
TARGET    = signext_sim
TB        = lfsr_tb.v
SOURCE    = lfsr.v
VVP       = vvp
VIEWER    = gtkwave

all: run

$(TARGET): $(TB) $(SOURCE)
	$(CC) $(FLAGS) -o $(TARGET) $(TB) $(SOURCE)

run: $(TARGET)
	$(VVP) $(TARGET)

clean:
	rm -f $(TARGET) *.vcd

.PHONY: all run waves clean
