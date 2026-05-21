`define OPCODE_OP     7'b0110011
`define OPCODE_OP_IMM 7'b0010011
`define OPCODE_JALR   7'b1100111
`define OPCODE_LOAD   7'b0000011
`define OPCODE_STORE  7'b0100011
`define OPCODE_BRANCH 7'b1100011
`define OPCODE_LUI    7'b0110111
`define OPCODE_AUIPC  7'b0010111
`define OPCODE_JAL    7'b1101111

`define FUNC3_ADD 3'b000
`define FUNC7_5_ADD 1'b0
`define FUNC7_5_SUB 1'b1

`define ALU_A_U_IMM 0
`define ALU_A_B_IMM 1
`define ALU_A_J_IMM 2
`define ALU_A_SRC_1 3

`define ALU_B_SRC_2 0
`define ALU_B_I_IMM 1
`define ALU_B_S_IMM 2
`define ALU_B_PC    3

`define WB_U_IMM  0
`define WB_ALU    1
`define WB_LSU    2
`define WB_PC_INC 3