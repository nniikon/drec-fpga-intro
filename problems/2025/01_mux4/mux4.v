module mux4 #(
    parameter WIDTH = 32
)(
    input wire [WIDTH-1:0] i_in1,
    input wire [WIDTH-1:0] i_in2,
    input wire [WIDTH-1:0] i_in3,
    input wire [WIDTH-1:0] i_in4,

    input wire [1:0] i_select,

    output reg [WIDTH-1:0] o_out
);

always @(*) begin
    case (i_select)
        2'b00:   o_out = i_in1;
        2'b01:   o_out = i_in2;
        2'b10:   o_out = i_in3;
        2'b11:   o_out = i_in4;
        default: o_out = {WIDTH{1'bx}};
    endcase 
end

endmodule