module core(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] i_instr_data,
    output wire [29:0] o_instr_addr,
    output wire [29:0] o_mem_addr,
    output wire [31:0] o_mem_data,
    output wire        o_mem_we,
    output wire  [3:0] o_mem_mask,
    input  wire [31:0] i_mem_data
);

reg  [29:0] pc;
wire [29:0] pc_inc = pc + 29'b1;

assign o_instr_addr = pc;

wire [31:0] pc_padded     = {pc, 2'b0};
wire [31:0] pc_inc_padded = {pc_inc, 2'b0};

wire [31:0] decode_u_imm;
wire [31:0] decode_b_imm;
wire [31:0] decode_j_imm;
wire  [4:0] decode_rs1;
wire  [4:0] decode_rs2;
wire  [4:0] decode_rd;
wire [31:0] decode_i_imm;
wire [31:0] decode_s_imm;

decoder decoder_inst(
    .i_instr(i_instr_data),

    .o_u_imm(decode_u_imm),
    .o_b_imm(decode_b_imm),
    .o_j_imm(decode_j_imm),
    .o_rs1(decode_rs1),
    .o_rs2(decode_rs2),
    .o_rd(decode_rd),
    .o_i_imm(decode_i_imm),
    .o_s_imm(decode_s_imm)
);

wire [1:0]  ctrl_alu_sel_1;
wire [1:0]  ctrl_alu_sel_2;
wire [3:0]  ctrl_alu_op;
wire [2:0]  ctrl_cmp_op;
wire        ctrl_branch;
wire        ctrl_jump;
wire [1:0]  ctrl_wb_sel;
wire        ctrl_lsu_wren;
wire        ctrl_rf_wren;

control control_inst (
    .i_instr(i_instr_data),
    .o_alu_sel_1(ctrl_alu_sel_1),
    .o_alu_sel_2(ctrl_alu_sel_2),
    .o_alu_op(ctrl_alu_op),
    .o_cmp_op(ctrl_cmp_op),
    .o_branch(ctrl_branch),
    .o_jump(ctrl_jump),
    .o_wb_sel(ctrl_wb_sel),
    .o_lsu_wren(ctrl_lsu_wren),
    .o_regfile_wren(ctrl_rf_wren)
);

wire [31:0] rs1_data;
wire [31:0] rs2_data;
wire [31:0] rd_data;

rf_2r1w #(
    .WIDTH(32),
    .DEPTH(32)
) rf_inst (
    .clk(clk),
    .i_wr_en(ctrl_rf_wren),
    .i_wr_addr(decode_rd),
    .i_wr_data(rd_data),

    .i_rd1_addr(decode_rs1),
    .o_rd1_data(rs1_data),

    .i_rd2_addr(decode_rs2),
    .o_rd2_data(rs2_data)
);

wire [31:0] alu_a;
wire [31:0] alu_b;

mux4 #(
    .WIDTH(32)
) alu_a_mux (
    .i_in1(decode_u_imm),
    .i_in2(decode_b_imm),
    .i_in3(decode_j_imm),
    .i_in4(rs1_data),

    .i_select(ctrl_alu_sel_1),

    .o_out(alu_a)
);

mux4 #(
    .WIDTH(32)
) alu_b_mux (
    .i_in1(rs2_data),
    .i_in2(decode_i_imm),
    .i_in3(decode_s_imm),
    .i_in4(pc_padded),

    .i_select(ctrl_alu_sel_2),

    .o_out(alu_b)
);

wire [31:0] alu_res;
wire alu_exception; // not used

rv32i_alu alu_inst (
    .i_funct7_5(ctrl_alu_op[3]),
    .i_funct3(ctrl_alu_op[2:0]),
    .i_rs1(alu_a),
    .i_rs2(alu_b),

    .o_rd(alu_res),
    .exception(alu_exception)
);

wire [31:0] lsu_data;
wire [2:0] instr_func3 = i_instr_data[14:12];

lsu lsu_inst(
    .i_addr(alu_res),        // from core
    .i_store_data(rs2_data), // from core
    .i_wren(ctrl_lsu_wren),  // from core
    .i_func3(instr_func3),   // from core
    .i_mem_data(i_mem_data), // from xbar

    .o_load_data(lsu_data),  // to core
    .o_mem_addr(o_mem_addr), // to xbar
    .o_mem_data(o_mem_data), // to xbar
    .o_mem_we(o_mem_we),     // to xbar
    .o_mem_mask(o_mem_mask)  // to xbar
);

mux4 #(
    .WIDTH(32)
) wb_mux (
    .i_in1(decode_u_imm),
    .i_in2(alu_res),
    .i_in3(lsu_data),
    .i_in4(pc_inc_padded),
    .i_select(ctrl_wb_sel),
    .o_out(rd_data)
);

wire cmp_unit_res;
wire cmp_unit_exception; // not used

rv32i_cmp cmp_unit_instr(
    .i_rs1(rs1_data),
    .i_rs2(rs2_data),
    .i_funct3(instr_func3),
    .o_res(cmp_unit_res),
    .o_exception(cmp_unit_exception)
);

wire branch_taken = (cmp_unit_res && ctrl_branch) || ctrl_jump;

wire [29:0] pc_next = branch_taken ? alu_res[31:2] // should be aligned
                                   : pc_inc;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        pc <= 30'b0;
    else
        pc <= pc_next;
end

endmodule
