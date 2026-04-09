`timescale 1ns / 1ps

module lfsr_tb;

parameter WIDTH = 8;

reg clk = 1;
reg rst_n = 0;

reg [WIDTH-1:0] o_data;

lfsr #(
    .WIDTH(WIDTH)
) lfsr_inst (
    .clk(clk),
    .rst_n(rst_n),
    .o_data(o_data)
);

always #1 clk = ~clk;

initial begin
    rst_n = 0;
    #20;
    rst_n = 1;
    #20;

    for (integer i = 0; i < 50; i = i + 1) begin
        @(negedge clk);
        $display("%d", o_data);
    end

    $finish;
end

endmodule