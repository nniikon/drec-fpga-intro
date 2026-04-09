`timescale 1ns / 1ps

module clkdiv_tb;

localparam TOTAL_TIME = 100_000_000;

reg clk = 1;
reg rst_n;
reg [1:0] select;

wire clk_out;

integer counter_original = 0;
integer counter_slowed   = 0;

clkdiv clkdiv_inst (
    .clk(clk),
    .rst_n(rst_n),
    .i_select(select),
    .o_clk(clk_out)
);

always begin
    clk = ~clk;
    #10; // for 50MGz
end

initial begin
    select = 0;
    rst_n = 0; #100;
    rst_n = 1;
end

always @(posedge clk) begin
    counter_original <= counter_original + 1;
end

always @(posedge clk) begin
    if (clk_out) begin
        counter_slowed <= counter_slowed + 1;
    end
end

initial begin
    #TOTAL_TIME
    $display("%d", counter_original);
    $display("%d", counter_slowed);
    $display("expected=%f; got=%f", 
             50_000_000.0 / 9600.0, 
             (counter_original * 1.0) / counter_slowed);
    $finish;
end


endmodule