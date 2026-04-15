module rf_2r1w #(
    parameter WIDTH = 32,
    parameter DEPTH = 32,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                   clk,

    input  wire                   i_wr_en,
    input  wire [ADDR_WIDTH-1:0]  i_wr_addr,
    input  wire [WIDTH-1:0]       i_wr_data,

    input  wire [ADDR_WIDTH-1:0]  i_rd1_addr,
    output wire [WIDTH-1:0]       o_rd1_data,

    input  wire [ADDR_WIDTH-1:0]  i_rd2_addr,
    output wire [WIDTH-1:0]       o_rd2_data
);

reg [WIDTH-1:0] data [0:DEPTH-1];

assign o_rd1_data = (i_rd1_addr == 0) ? {(WIDTH){1'b0}} : data[i_rd1_addr];
assign o_rd2_data = (i_rd2_addr == 0) ? {(WIDTH){1'b0}} : data[i_rd2_addr];

always @(posedge clk) begin
    if (i_wr_en) begin
        data[i_wr_addr] <= i_wr_data;
    end
end

endmodule