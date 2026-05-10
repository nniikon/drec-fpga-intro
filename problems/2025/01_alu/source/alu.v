module rv32i_alu #(
    parameter WIDTH = 32,
    parameter MASK  = 32'h1F
)(
    input  wire           i_funct7_5,
    input  wire [2:0]     i_funct3,
    input  wire [WIDTH-1:0] i_rs1,
    input  wire [WIDTH-1:0] i_rs2,

    output reg [WIDTH-1:0]  o_rd,
    output reg              exception
);

always @(*) begin
    exception = 1'b0;
    case (i_funct3)
        3'b000: begin // ADD, SUB
            if (i_funct7_5 == 1'b1) begin
                o_rd = i_rs1 - i_rs2; // SUB
            end else begin
                o_rd = i_rs1 + i_rs2; // ADD
            end
        end
        3'b001: o_rd = i_rs1 << (i_rs2 & MASK); // SLL
        3'b010: o_rd =   $signed(i_rs1) <   $signed(i_rs2) ? 1'b1 : 1'b0; // SLT
        3'b011: o_rd = $unsigned(i_rs1) < $unsigned(i_rs2) ? 1'b1 : 1'b0; // SLTU
        3'b100: o_rd = i_rs1 ^ i_rs2; // XOR
        3'b101: begin // SRL, SRA
            if (i_funct7_5 == 1'b1) begin
                o_rd =   $signed(i_rs1) >>> (i_rs2 & MASK); // SRA
            end else begin
                o_rd = $unsigned(i_rs1) >>  (i_rs2 & MASK); // SRL
            end
        end
        3'b110: o_rd = i_rs1 | i_rs2; // OR
        3'b111: o_rd = i_rs1 & i_rs2; // AND

        default: exception = 1'b1;
    endcase
end

endmodule