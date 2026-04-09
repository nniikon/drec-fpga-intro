CC        = iverilog
FLAGS     = -g2012 -Wall
TARGET    = signext_sim
TB        = mux4_tb.v
SOURCE    = mux4.v
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