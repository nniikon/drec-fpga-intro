`timescale 1ns / 1ps

module sign_extender_behav #(
    parameter WIDTH_IN  = 8,
    parameter WIDTH_OUT = 16
)(
    input  wire [WIDTH_IN -1:0] i_int,
    output wire [WIDTH_OUT-1:0] o_int
);

assign o_int = {{(WIDTH_OUT-WIDTH_IN){i_int[WIDTH_IN-1]}}, i_int};

endmodule
