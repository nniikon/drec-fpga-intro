module clkdiv #(
    parameter F1 = 50_000_000,
    parameter F2 = 9600
)(
    input  wire     clk,
    input  wire     rst_n,
    output wire     o_clk
);

localparam CNT_WIDTH = $clog2(F1/F2);

reg [CNT_WIDTH-1:0] counter;

assign o_clk = (counter == F1/F2);

always @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        counter <= {(CNT_WIDTH){1'b0}};
    else if (o_clk)
        counter <= {(CNT_WIDTH){1'b0}};
    else
        counter <= counter + 1;
end

endmodule