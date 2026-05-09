
`timescale 1ns/1ps

module uart_tb;

localparam FREQ = 50_000_000;
localparam RATE = 2_000_000;

localparam N_TESTS = 100;

reg clk   = 1'b0;
reg rst_n = 1'b0;

always #10 clk = ~clk; // 50 MHz

wire connector;

reg  [7:0] input_data;
wire [7:0] output_data;

wire input_rdy;

reg       vld_input;
wire      vld_output;

uart_tx #(
    .FREQ(FREQ),
    .RATE(RATE)
) uart_tx_inst (
    .clk   (clk),
    .rst_n (rst_n),
    .i_data(input_data),
    .i_vld (vld_input),
    .o_rdy (input_rdy),
    .o_tx  (connector)
);

uart_rx #(
    .FREQ(FREQ),
    .RATE(RATE)
) uart_rx_inst (
    .clk   (clk),
    .rst_n (rst_n),
    .i_rx  (connector),
    .o_data(output_data),
    .o_vld (vld_output)
);

task check_data_trans;
    reg [7:0] data;
    begin
        data = $urandom;

        wait (input_rdy);
        @(negedge clk);
        input_data <= data;
        vld_input  <= 1'b1;

        @(negedge clk);
        vld_input  <= 1'b0;

        @(posedge vld_output);
        @(posedge clk);

        if (data !== output_data) begin
            $display("[FAIL] got %b, expected %b", output_data, data);
            $finish;
        end
        else begin
            $display("SUCCESS");
        end
    end
endtask

initial begin
    $dumpvars;

    input_data = 8'h00;
    vld_input  = 1'b0;

    rst_n = 1'b0;
    repeat (5) @(posedge clk);
    rst_n = 1'b1;

    repeat (5) @(posedge clk);

    repeat (N_TESTS) begin
        check_data_trans();
    end

    $display("[PASS] all tests completed");
    $finish;
end

endmodule