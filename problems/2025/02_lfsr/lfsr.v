module lfsr #(
    parameter WIDTH = 8
)(
    input  wire clk,
    input  wire rst_n,

    output wire [WIDTH-1:0] o_data
);

reg [WIDTH-1:0] data;

assign o_data = data;

integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < WIDTH; i = i + 1) begin
            data[i] <= i % 2;
        end
    end
    else begin
        data <= { data[0] ^ data[WIDTH - 1], data[WIDTH-1:1] };
    end
end

endmodule