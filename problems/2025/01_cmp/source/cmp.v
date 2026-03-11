module rv32i_cmp #(
    parameter WIDTH = 32
)(
    input wire [WIDTH-1:0] i_rs1,
    input wire [WIDTH-1:0] i_rs2,

    input wire [2:0] i_funct3,

    output reg o_res,
    output reg o_exception
);

always @(*) begin
    o_exception = 1'b0;
    case (i_funct3)
        3'b000: o_res = i_rs1 == i_rs2;                       // beq
        3'b001: o_res = i_rs1 != i_rs2;                       // bne
        3'b100: o_res =   $signed(i_rs1) <    $signed(i_rs2); // blt
        3'b101: o_res =   $signed(i_rs1) >=   $signed(i_rs2); // bge
        3'b110: o_res = $unsigned(i_rs1) <  $unsigned(i_rs2); // bltu
        3'b111: o_res = $unsigned(i_rs1) >= $unsigned(i_rs2); // bgeu
        default: begin
            o_exception = 1'b1;
        end
    endcase

end

endmodule