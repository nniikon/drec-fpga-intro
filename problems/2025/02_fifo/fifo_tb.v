`timescale 1ns / 1ps

module fifo_tb;

localparam N_TESTS = 1000;

parameter WIDTH = 32;
parameter DEPTH = 16;

reg              clk;
reg              rst_n;
reg  [WIDTH-1:0] i_wr_data;
reg              i_wr_en;
reg              o_wr_full;
reg [WIDTH-1:0]  o_rd_data;
reg              i_rd_en;
reg              o_rd_empty;

integer failed   = 0;
integer test_num = 0;

fifo #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) fifo_inst (
    .clk       (clk),
    .rst_n     (rst_n),
    .i_wr_data (i_wr_data),
    .i_wr_en   (i_wr_en),
    .o_wr_full (o_wr_full),
    .o_rd_data (o_rd_data),
    .i_rd_en   (i_rd_en),
    .o_rd_empty(o_rd_empty)
);

always #10 clk = ~clk;

task fifo_reset();
    begin
        rst_n     = 1'b0;
        i_wr_en   = 1'b0;
        i_rd_en   = 1'b0;
        i_wr_data = {(WIDTH){1'b0}};
        repeat(10) @(negedge clk);
        rst_n     = 1'b1;
    end
endtask

task fifo_write_data(input [WIDTH-1:0] data);
    begin
        @(negedge clk);
        if (o_wr_full) begin
            $display("fifo_write_data: overflow");
        end else begin
            i_wr_en   = 1'b1;
            i_wr_data = data;
            @(negedge clk);
            i_wr_en   = 1'b0;
        end
    end
endtask

task fifo_read_data(output [WIDTH-1:0] data);
    begin
        @(negedge clk);
        if (o_rd_empty) begin
            $display("fifo_read_data: underflow");
        end else begin
            i_rd_en = 1'b1;
            @(negedge clk);
            i_rd_en = 1'b0;
            data    = o_rd_data;
        end
    end
endtask

task fifo_read_and_check(input [WIDTH-1:0] expected_data);
    reg [WIDTH-1:0] read_data;
    begin
        fifo_read_data(read_data);
        if (read_data !== expected_data) begin
            $display("FAIL Test %0d: expected %h, got %h", test_num, expected_data, read_data);
            failed = failed + 1;
        end
        test_num = test_num + 1;
    end
endtask

initial begin
    clk = 0;

    fifo_reset();

    fifo_write_data(32'hAAAA_1111);
    fifo_write_data(32'hBBBB_2222);
    fifo_write_data(32'hCCCC_3333);

    fifo_read_and_check(32'hAAAA_1111);
    fifo_read_and_check(32'hBBBB_2222);
    fifo_read_and_check(32'hCCCC_3333);

    if (failed == 0) begin
        $display("SUCCESS: [%0d] tests passed!", test_num);
    end else begin
        $display("FAIL: [%0d]/[%0d] tests failed.", failed, test_num);
    end

    $finish;
end

endmodule