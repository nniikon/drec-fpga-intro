module fifo #(
    parameter WIDTH = 32,
    parameter DEPTH = 16
)(
    input  wire             clk,
    input  wire             rst_n,

    input  wire [WIDTH-1:0] i_wr_data,
    input  wire             i_wr_en,
    output wire             o_wr_full,

    output reg  [WIDTH-1:0] o_rd_data,
    input  wire             i_rd_en,
    output wire             o_rd_empty
);

localparam ADDRESS_WIDTH = $clog2(DEPTH);

reg [WIDTH-1:0] memory [DEPTH-1:0];

reg [ADDRESS_WIDTH:0] head;
reg [ADDRESS_WIDTH:0] tail;

assign o_rd_empty = (head == tail);
assign o_wr_full  = (head[ADDRESS_WIDTH]     != tail[ADDRESS_WIDTH]) &&
                    (head[ADDRESS_WIDTH-1:0] == tail[ADDRESS_WIDTH-1:0]);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        head      <= {(ADDRESS_WIDTH + 1){1'b0}};
        tail      <= {(ADDRESS_WIDTH + 1){1'b0}};
        o_rd_data <= {WIDTH{1'b0}};
    end else begin
        if (i_wr_en && !o_wr_full) begin
            memory[head[ADDRESS_WIDTH-1:0]] <= i_wr_data;
            head <= head + 1'b1;
        end

        if (i_rd_en && !o_rd_empty) begin
            o_rd_data <= memory[tail[ADDRESS_WIDTH-1:0]];
            tail <= tail + 1'b1;
        end
    end
end

endmodule