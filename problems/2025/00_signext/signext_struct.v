`timescale 1ns / 1ps

module sign_extender_struct #(
    parameter WIDTH_IN  = 8,
    parameter WIDTH_OUT = 16
)(
    input  wire [WIDTH_IN -1:0] i_int,
    output wire [WIDTH_OUT-1:0] o_int
);

genvar i;
generate
for (i = 0; i < WIDTH_IN; i = i + 1) begin : copy
    assign o_int[i] = i_int[i];
end

for (i = WIDTH_IN; i < WIDTH_OUT; i = i + 1) begin : extend
    assign o_int[i] = i_int[WIDTH_IN - 1];
end
endgenerate

endmodule