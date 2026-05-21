`include "config.vh"

module fpga_top(
    input  wire CLK,
    input  wire RSTN,

    output wire STCP,
    output wire SHCP,
    output wire DS,
    output wire OE
);

reg rst_n, RSTN_d;

wire  [3:0] anodes;
wire  [7:0] segments;

wire pll_clk;

pll pll_inst(
    .inclk0(CLK),
    .c0(pll_clk)
);

always @(posedge pll_clk) begin
    rst_n  <= RSTN_d;
    RSTN_d <= RSTN;
end

system_top system_top (
    .clk         (pll_clk   ),
    .rst_n       (rst_n     ),
    .anodes      (anodes    ),
    .segments    (segments  )
);

ctrl_74hc595 ctrl_74hc595 (
    .clk        (pll_clk            ),
    .rst_n      (rst_n              ),
    .i_data     ({segments, anodes} ),
    .o_stcp     (STCP               ),
    .o_shcp     (SHCP               ),
    .o_ds       (DS                 ),
    .o_oe       (OE                 )
);

endmodule
