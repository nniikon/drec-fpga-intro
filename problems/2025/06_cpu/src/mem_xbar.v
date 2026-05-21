module mem_xbar #(
    parameter DATA_START = 30'h0400,
    parameter DATA_LIMIT = 30'h3FFF,
    parameter MMIO_START = 30'h0000,
    parameter MMIO_LIMIT = 30'h03FF
)(
    input  wire        clk,

    input  wire [29:0] i_addr,
    input  wire [31:0] i_data,
    input  wire        i_wren,
    input  wire  [3:0] i_mask,
    output reg  [31:0] o_data,

    output reg  [29:0] o_dmem_addr,
    output reg  [31:0] o_dmem_data,
    output reg   [3:0] o_dmem_mask,
    output reg         o_dmem_wren,
    input  wire [31:0] i_dmem_data,

    output reg  [29:0] o_mmio_addr,
    output reg  [31:0] o_mmio_data,
    output reg         o_mmio_wren,
    output reg   [3:0] o_mmio_mask,
    input  wire [31:0] i_mmio_data
);

wire is_dmem = (i_addr >= DATA_START && i_addr <= DATA_LIMIT);
wire is_mmio = (i_addr >= MMIO_START && i_addr <= MMIO_LIMIT);

localparam STATE_DMEM = 1'b0,
           STATE_MMIO = 1'b1;

reg prev_state;

always @(posedge clk) begin
    if (is_dmem)
        prev_state <= STATE_DMEM;
    else if (is_mmio)
        prev_state <= STATE_MMIO;
    else
        prev_state <= 1'bX;
end

always @(*) begin
    o_mmio_addr = {30{1'bX}};
    o_mmio_data = {32{1'bX}};
    o_mmio_mask = { 4{1'b0}};
    o_mmio_wren =     1'b0;

    o_dmem_addr = {30{1'bX}};
    o_dmem_data = {32{1'bX}};
    o_dmem_mask = { 4{1'b0}};
    o_dmem_wren =     1'b0;

    o_data = {32{1'bX}};

    if (is_mmio) begin
        o_mmio_addr = i_addr - MMIO_START;
        o_mmio_data = i_data;
        o_mmio_mask = i_mask;
        o_mmio_wren = i_wren;
    end
    else if (is_dmem) begin
        o_dmem_addr = i_addr - DATA_START;
        o_dmem_data = i_data;
        o_dmem_mask = i_mask;
        o_dmem_wren = i_wren;
    end

    if (prev_state == STATE_MMIO) begin
        o_data = i_mmio_data;
    end
    else if (prev_state == STATE_DMEM) begin
        o_data = i_dmem_data;
    end
end

endmodule
