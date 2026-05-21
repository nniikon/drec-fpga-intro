`include "control_consts.vh"

module control (
    input  wire [31:0] i_instr,

    output reg  [1:0]  o_alu_sel_1,
    output reg  [1:0]  o_alu_sel_2,
    output reg  [3:0]  o_alu_op,
    output reg  [2:0]  o_cmp_op,
    output reg         o_branch,
    output reg         o_jump,
    output reg  [1:0]  o_wb_sel,
    output reg         o_need_stall,

    output reg         o_lsu_wren,
    output reg         o_regfile_wren
);

wire [6:0] op    = i_instr[6:0];
wire [2:0] func3 = i_instr[14:12];
wire [6:0] func7 = i_instr[31:25];

wire is_opcode_op     = (op == `OPCODE_OP);
wire is_opcode_op_imm = (op == `OPCODE_OP_IMM);
wire is_opcode_jalr   = (op == `OPCODE_JALR);
wire is_opcode_load   = (op == `OPCODE_LOAD);
wire is_opcode_store  = (op == `OPCODE_STORE);
wire is_opcode_branch = (op == `OPCODE_BRANCH);
wire is_opcode_lui    = (op == `OPCODE_LUI);
wire is_opcode_auipc  = (op == `OPCODE_AUIPC);
wire is_opcode_jal    = (op == `OPCODE_JAL);

always @(*) begin
    o_alu_sel_1    = 2'b0;
    o_alu_sel_2    = 2'b0;
    o_alu_op       = 4'b0;
    o_cmp_op       = 3'b0;
    o_branch       = 1'b0;
    o_jump         = 1'b0;
    o_wb_sel       = `WB_ALU;
    o_need_stall   = 1'b0;
    o_lsu_wren     = 1'b0;
    o_regfile_wren = 1'b0;

    if (is_opcode_op) begin
        o_alu_sel_1 = `ALU_A_SRC_1;
        o_alu_sel_2 = `ALU_B_SRC_2;
        o_alu_op = {func7[5], func3};

        o_wb_sel = `WB_ALU;
        o_regfile_wren = 1'b1;
    end
    else if (is_opcode_op_imm) begin
        o_alu_sel_1 = `ALU_A_SRC_1;
        o_alu_sel_2 = `ALU_B_I_IMM;
        if (func3 == 3'b101) begin
            o_alu_op = {func7[5], func3}; // SRLI/SRAI
        end else begin
            o_alu_op = {1'b0, func3};
        end

        o_wb_sel       = `WB_ALU;
        o_regfile_wren = 1'b1;
    end
    else if (is_opcode_jalr) begin
        o_alu_sel_1 = `ALU_A_SRC_1;
        o_alu_sel_2 = `ALU_B_I_IMM;
        o_alu_op = {`FUNC7_5_ADD, `FUNC7_5_ADD};

        o_jump = 1'b1;

        o_wb_sel = `WB_PC_INC;
        o_regfile_wren = 1'b1;
    end
    else if (is_opcode_load) begin
        o_alu_sel_1 = `ALU_A_SRC_1;
        o_alu_sel_2 = `ALU_B_I_IMM;
        o_alu_op = {`FUNC7_5_ADD, `FUNC7_5_ADD};

        o_need_stall = 1'b1;

        o_wb_sel       = `WB_LSU;
        o_regfile_wren = 1'b1;
    end
    else if (is_opcode_store) begin
        o_alu_sel_1 = `ALU_A_SRC_1;
        o_alu_sel_2 = `ALU_B_S_IMM;
        o_alu_op = {`FUNC7_5_ADD, `FUNC7_5_ADD};

        o_lsu_wren = 1'b1;
    end
    else if (is_opcode_branch) begin
        o_alu_sel_1 = `ALU_A_B_IMM;
        o_alu_sel_2 = `ALU_B_PC;
        o_alu_op = {`FUNC7_5_ADD, `FUNC7_5_ADD};

        o_cmp_op = func3;
        o_branch = 1'b1;
    end
    else if (is_opcode_lui) begin
        o_wb_sel = `WB_U_IMM;
        o_regfile_wren = 1'b1;
    end
    else if (is_opcode_auipc) begin
        o_alu_sel_1 = `ALU_A_U_IMM;
        o_alu_sel_2 = `ALU_B_PC;
        o_alu_op = {`FUNC7_5_ADD, `FUNC7_5_ADD};

        o_wb_sel = `WB_ALU;
        o_regfile_wren = 1'b1;
    end
    else if (is_opcode_jal) begin
        o_alu_sel_1 = `ALU_A_J_IMM;
        o_alu_sel_2 = `ALU_B_PC;
        o_alu_op = {`FUNC7_5_ADD, `FUNC7_5_ADD};

        o_wb_sel = `WB_PC_INC;
        o_regfile_wren = 1'b1;

        o_jump = 1'b1;
    end
end

endmodule