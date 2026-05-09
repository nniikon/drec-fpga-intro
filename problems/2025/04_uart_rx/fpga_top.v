module fpga_top(
    input  wire CLK,
    input  wire RSTN,
    output wire STCP,
    output wire SHCP,
    output wire DS,
    output wire OE,
    input  wire RXD,
    output wire TXD,
    output wire [11:0] LED
);

reg rst_n, RSTN_d;

reg [15:0] out_data;
wire [7:0]   rx_data;
wire vld;

always @(posedge CLK) begin
    rst_n <= RSTN_d;
    RSTN_d <= RSTN;
end

wire [3:0] anodes;
wire [7:0] segments;

hex_display hex_display(CLK, rst_n, out_data, 4'b0000, anodes, segments);

ctrl_74hc595 ctrl(
    .clk    (CLK                ),
    .rst_n  (rst_n              ),
    .i_data ({segments, anodes} ),
    .o_stcp (STCP               ),
    .o_shcp (SHCP               ),
    .o_ds   (DS                 ),
    .o_oe   (OE                 )
);

uart_rx #(
    .FREQ(50_000_000),
    .RATE(2_000_000)
) uart_inst (
    .clk(CLK),
    .rst_n(RSTN),

    .i_rx(RXD),

    .o_data(rx_data),
    .o_vld(vld)
);

always @(posedge CLK) begin
    if (!rst_n) begin
        out_data <= {16{1'b0}};
    end
    else begin
        if (vld) begin
            out_data <= {out_data[7:0], rx_data};
        end
    end
end

endmodule