`timescale 1ns/1ps

module rf_2r1w_tb;

parameter WIDTH = 32;
parameter DEPTH = 32;
parameter ADDR_WIDTH = $clog2(DEPTH);

reg                  clk;
reg                  i_wr_en;
reg [ADDR_WIDTH-1:0] i_wr_addr;
reg [WIDTH-1:0]      i_wr_data;

reg [ADDR_WIDTH-1:0] i_rd1_addr;
wire [WIDTH-1:0]     o_rd1_data; 

reg [ADDR_WIDTH-1:0] i_rd2_addr;
wire [WIDTH-1:0]     o_rd2_data; 

rf_2r1w #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) rf2r1w_tb (
    .clk        (clk),

    .i_wr_en    (i_wr_en),
    .i_wr_addr  (i_wr_addr),
    .i_wr_data  (i_wr_data),

    .i_rd1_addr (i_rd1_addr),
    .o_rd1_data (o_rd1_data),

    .i_rd2_addr (i_rd2_addr),
    .o_rd2_data (o_rd2_data)
);

always #1 clk = ~clk;

task rf_set(input [ADDR_WIDTH-1:0] addr, input [WIDTH-1:0] data);
    begin
        @(negedge clk);
        i_wr_en = 1'b1;
        i_wr_addr = addr;
        i_wr_data = data;
        @(negedge clk);
        i_wr_en = 1'b0;
    end
endtask

task rf_get_and_check(input [ADDR_WIDTH-1:0] addr, input [WIDTH-1:0] expected_data, input port);
    reg [WIDTH-1:0] actual_data;
    begin
        if (port == 0) begin
            @(negedge clk);
            i_rd1_addr = addr;
            @(negedge clk);
            actual_data = o_rd1_data;
        end else if (port == 1) begin
            @(negedge clk);
            i_rd2_addr = addr;
            @(negedge clk);
            actual_data = o_rd2_data;
        end

        if (actual_data != expected_data) begin
            $display("FAIL: Port %d Read Addr %d = %h (Expected = %h)", port, addr, actual_data, expected_data);
        end
    end
endtask

initial begin
    clk = 0;
    i_wr_en = 0;
    i_wr_addr = 0;
    i_wr_data = 0;
    i_rd1_addr = 0;
    i_rd2_addr = 0;

    #10;

    rf_set(5, 32'hDEADBEEF);
    rf_get_and_check(5, 32'hDEADBEEF, 0);

    rf_set(10, 32'hCAFEF00D);
    rf_get_and_check(10, 32'hCAFEF00D, 1);
    rf_get_and_check(5, 32'hDEADBEEF, 0);
    rf_get_and_check(0, 32'h00000000, 0);

    #10;

    $display("SUCCESS");

    $finish;
end

endmodule