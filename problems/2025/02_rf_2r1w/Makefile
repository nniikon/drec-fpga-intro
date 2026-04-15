CC        = iverilog
FLAGS     = -g2012 -Wall
TARGET    = signext_sim
TB        = rf_2r1w.v
SOURCE    = rf_2r1w_tb.v
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

