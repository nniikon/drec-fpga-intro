module decoder (
    input  wire [31:0] i_instr,

    output wire [31:0] o_u_imm,
    output wire [31:0] o_b_imm,
    output wire [31:0] o_j_imm,
    output wire  [4:0] o_rs1,
    output wire  [4:0] o_rs2,
    output wire  [4:0] o_rd,
    output wire [31:0] o_i_imm,
    output wire [31:0] o_s_imm
);

assign o_rd  = i_instr[11:7];
assign o_rs1 = i_instr[19:15];
assign o_rs2 = i_instr[24:20];

assign o_i_imm = {{20{i_instr[31]}}, i_instr[31:20]};
assign o_s_imm = {{20{i_instr[31]}}, i_instr[31:25], i_instr[11:7]};
assign o_b_imm = {{19{i_instr[31]}}, i_instr[31], i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0};
assign o_u_imm = {i_instr[31:12], 12'b0};
assign o_j_imm = {{11{i_instr[31]}}, i_instr[31], i_instr[19:12], i_instr[20], i_instr[30:21], 1'b0};

endmodule
