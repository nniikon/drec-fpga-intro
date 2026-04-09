`timescale 1ns/1ps

module mux4_tb #(
    parameter WIDTH = 32
);

localparam TEST_NUM = 1000;

reg [WIDTH-1:0] in1;
reg [WIDTH-1:0] in2;
reg [WIDTH-1:0] in3;
reg [WIDTH-1:0] in4;

reg [1:0] select;

wire [WIDTH-1:0] out; 

mux4 #(
    .WIDTH(WIDTH)
) mux4_inst(
    .i_in1(in1),
    .i_in2(in2),
    .i_in3(in3),
    .i_in4(in4),
    .i_select(select),
    .o_out(out)
);

integer failed = 0;

initial begin
    $dumpfile("mux4_tb.vcd");
    $dumpvars(0, mux4_tb);

    for (integer i = 0; i < TEST_NUM; i = i + 1) begin
        in1 = $urandom;
        in2 = $urandom;
        in3 = $urandom;
        in4 = $urandom;

        select = 2'b00;
        #5;
        if (out !== in1) begin
            failed = failed + 1;
            $display("FAIL [Iter %0d]: select=00, expected=%h, got=%h", i, in1, out);
        end

        select = 2'b01;
        #5;
        if (out !== in2) begin
            failed = failed + 1;
            $display("FAIL [Iter %0d]: select=01, expected=%h, got=%h", i, in2, out);
        end

        select = 2'b10;
        #5;
        if (out !== in3) begin
            failed = failed + 1;
            $display("FAIL [Iter %0d]: select=10, expected=%h, got=%h", i, in3, out);
        end

        select = 2'b11;
        #5;
        if (out !== in4) begin
            failed = failed + 1;
            $display("FAIL [Iter %0d]: select=11, expected=%h, got=%h", i, in4, out);
        end
    end

    if (failed == 0) begin
        $display("SUCCESS: [%0d] tests passed!", 4*TEST_NUM);
    end else begin
        $display("FAIL: [%0d]/[%0d] tests failed.", failed, 4*TEST_NUM);
    end

    $finish;
end

endmodule