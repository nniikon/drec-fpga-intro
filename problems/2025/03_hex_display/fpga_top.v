module fpga_top(
    input  wire CLK,   // CLOCK
    input  wire RSTN,  // BUTTON RST (NEGATIVE)
    output wire STCP,
    output wire SHCP,
    output wire DS,
    output wire OE
);

reg rst_n, RSTN_d;

reg [20:0] cnt;
reg [15:0] data;

always @(posedge CLK) begin
    rst_n <= RSTN_d;
    RSTN_d <= RSTN;
end

always @(posedge CLK) begin
    if (!rst_n) begin
        cnt <= 0;
        data <= 0;
    end else begin
        cnt <= cnt + 1;
        if (cnt == 0) begin
            data <= data + 1;
        end
    end
end

wire  [3:0] anodes;
wire  [7:0] segments;

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
