module lsu(
    input  wire [31:0] i_addr,       // from core
    input  wire [31:0] i_store_data, // from core
    input  wire        i_wren,       // from core
    input  wire  [2:0] i_func3,      // from core
    input  wire [31:0] i_mem_data,   // from xbar

    output reg  [31:0] o_load_data,   // to core
    output wire [29:0] o_mem_addr,    // to xbar
    output wire [31:0] o_mem_data,    // to xbar
    output wire        o_mem_we,      // to xbar
    output reg  [3:0] o_mem_mask     // to xbar
);

wire is_lb  = ((i_func3 == 3'b000) && (i_wren == 1'b0));
wire is_sb  = ((i_func3 == 3'b000) && (i_wren == 1'b1));

wire is_lh  = ((i_func3 == 3'b001) && (i_wren == 1'b0));
wire is_sh  = ((i_func3 == 3'b001) && (i_wren == 1'b1));

wire is_lbu = ((i_func3 == 3'b100) && (i_wren == 1'b0));
wire is_lhu = ((i_func3 == 3'b101) && (i_wren == 1'b0));

assign o_mem_we = i_wren;
assign o_mem_addr = i_addr[31:2];

wire [1:0] shift = i_addr[1:0];
assign o_mem_data = i_store_data << (shift * 8);

wire [31:0] sext_b;
wire [31:0] sext_h;

wire [31:0] i_mem_data_shifted = (i_mem_data >> (shift * 8));

sign_extender_behav #(
    .WIDTH_IN(8),
    .WIDTH_OUT(32)
) sext_b_inst (
    .i_int(i_mem_data_shifted[7:0]),
    .o_int(sext_b)
);

sign_extender_behav #(
    .WIDTH_IN(16),
    .WIDTH_OUT(32)
) sext_h_inst (
    .i_int(i_mem_data_shifted[15:0]),
    .o_int(sext_h)
);

wire [31:0] zext_b = {24'b0, i_mem_data_shifted[ 7:0]};
wire [31:0] zext_h = {16'b0, i_mem_data_shifted[15:0]};


always @(*) begin
    if (is_lb || is_sb || is_lbu)
        o_mem_mask = 4'b0001 << shift;
    else if (is_lh || is_sh || is_lhu)
        o_mem_mask = 4'b0011 << shift;
    else
        o_mem_mask = 4'b1111;

    if      (is_lb)  o_load_data = sext_b;
    else if (is_lh)  o_load_data = sext_h;
    else if (is_lbu) o_load_data = zext_b;
    else if (is_lhu) o_load_data = zext_h;
    else             o_load_data = i_mem_data;

end

endmodule
