module tb_shiftreg;

localparam WIDTH = 8;

reg clk;
reg rst_n;
reg i_load_en;
reg [WIDTH-1:0] i_load_data;
reg i_lsb;

wire o_msb;

shiftreg #(
    .WIDTH(WIDTH)
) shiftreg_inst (
    .clk(clk),
    .rst_n(rst_n),
    .i_load_en(i_load_en),
    .i_load_data(i_load_data),
    .i_lsb(i_lsb),
    .o_msb(o_msb)
);

always #1 clk = ~clk;

task shiftreg_load(input [7:0] load_val);
    begin
        @(negedge clk);
        i_load_en = 1'b1;
        i_load_data = load_val;
        @(negedge clk);
        i_load_en = 1'b0;
    end
endtask

task shiftreg_get_and_check(input expected_msb);
    begin
        if (o_msb !== expected_msb) begin
            $display("FAIL: Expected %b, got %b", expected_msb, o_msb);
        end
    end
endtask

initial begin
    clk = 0;
    rst_n = 0;
    i_load_en = 0;
    i_load_data = 0;
    i_lsb = 0;

    #15 rst_n = 1;

    i_lsb = 1'b0;
    shiftreg_load(8'b10100101);

    shiftreg_get_and_check(1'b1);
    @(negedge clk);
    shiftreg_get_and_check(1'b0);
    @(negedge clk);
    shiftreg_get_and_check(1'b1);
    @(negedge clk);
    shiftreg_get_and_check(1'b0);
    @(negedge clk);
    shiftreg_get_and_check(1'b0);
    @(negedge clk);
    shiftreg_get_and_check(1'b1);
    @(negedge clk);
    shiftreg_get_and_check(1'b0);
    @(negedge clk);
    shiftreg_get_and_check(1'b1);
    @(negedge clk);
    shiftreg_get_and_check(1'b0);
    @(negedge clk);
    shiftreg_get_and_check(1'b0);
    @(negedge clk);
    shiftreg_get_and_check(1'b0);
    @(negedge clk);
    shiftreg_get_and_check(1'b0);
    i_lsb = 1'b1;
    repeat (50) @(posedge clk);
    i_lsb = 1'b0;
    shiftreg_get_and_check(1'b1);
    @(negedge clk);
    shiftreg_get_and_check(1'b1);
    @(negedge clk);
    shiftreg_get_and_check(1'b1);

    $finish;
end

endmodule