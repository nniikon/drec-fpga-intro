CC        = iverilog
FLAGS     = -g2012 -Wall
TARGET    = cmp_sim
TB        = tb/cmp_tb.v
SOURCE    = source/cmp.v
VVP       = vvp
VIEWER    = gtkwave

all: run

$(TARGET): $(TB) $(SOURCE)
	$(CC) $(FLAGS) -o $(TARGET) $(TB) $(SOURCE)

run: $(TARGET)
	$(VVP) $(TARGET)

waves: run
	$(VIEWER) dump.vcd &

clean:
	rm -f $(TARGET) *.vcd

.PHONY: all run waves clean
