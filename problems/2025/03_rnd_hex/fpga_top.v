module fpga_top(
    input  wire CLK,   // CLOCK
    input  wire RSTN,  // BUTTON RST (NEGATIVE)
    output wire STCP,
    output wire SHCP,
    output wire DS,
    output wire OE
);

reg rst_n, RSTN_d;

wire slow_clk;
wire [15:0] data;

always @(posedge CLK) begin
    rst_n <= RSTN_d;
    RSTN_d <= RSTN;
end

wire  [3:0] anodes;
wire  [7:0] segments;

clkdiv #(
    .F1(50_000_000),
    .F2(1)
) clkdiv (
    .clk(CLK),
    .rst_n(RSTN),
    .o_clk(slow_clk)
);

lfsr #(
    .WIDTH(16)
) lfsr (
    .clk(slow_clk),
    .rst_n(RSTN),

    .o_data(data)
);

hex_display hex_display(CLK, rst_n, data, 4'b0000, anodes, segments);

ctrl_74hc595 ctrl(
    .clk    (CLK                ),
    .rst_n  (rst_n              ),
    .i_data ({segments, anodes} ),
    .o_stcp (STCP               ),
    .o_shcp (SHCP               ),
    .o_ds   (DS                 ),
    .o_oe   (OE                 )
);

endmodule
