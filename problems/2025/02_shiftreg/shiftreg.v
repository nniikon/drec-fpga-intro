module shiftreg #(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst_n,

    input wire             i_load_en,
    input wire [WIDTH-1:0] i_load_data,

    input  wire i_lsb,
    output wire o_msb
);

reg [WIDTH-1:0] data;

assign o_msb = data[WIDTH-1];

always @(posedge clk) begin
    if (!rst_n) begin
        data <= {WIDTH{1'b0}};
    end else if (i_load_en) begin
        data <= i_load_data;
    end else begin
        data <= {data[WIDTH-2:0], i_lsb};
    end
end

endmodule