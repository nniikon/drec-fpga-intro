module dec10 (
    input  wire [3:0] in,
    input  wire       i_dec,
    input  wire       i_borrow,
    output wire [3:0] out,
    output wire       o_borrow
);

wire [1:0] dec = i_borrow + i_dec;

assign o_borrow = (in < dec);
assign out        = o_borrow ? (in + 4'd10 - dec)
                             : (in - dec);

endmodule

module timer (
    input  wire       clk,
    input  wire       rst_n,
    output wire [15:0] o_time
);

reg [3:0] time_reg [4];

wire [3:0] next0, next1, next2, next3;
wire borrow_1, borrow_2, borrow_3, borrow_4;

dec10 dec1 (
    .in       (time_reg[0]),
    .i_dec    (1'b1),
    .i_borrow (1'b0),
    .out      (next0),
    .o_borrow (borrow_1)
);

dec10 dec2 (
    .in       (time_reg[1]),
    .i_dec    (1'b0),
    .i_borrow (borrow_1),
    .out      (next1),
    .o_borrow (borrow_2)
);

dec10 dec3 (
    .in       (time_reg[2]),
    .i_dec    (1'b0),
    .i_borrow (borrow_2),
    .out      (next2),
    .o_borrow (borrow_3)
);

dec10 dec4 (
    .in       (time_reg[3]),
    .i_dec    (1'b0),
    .i_borrow (borrow_3),
    .out      (next3),
    .o_borrow (borrow_4)
);

assign o_time = {time_reg[3], time_reg[2], time_reg[1], time_reg[0]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        time_reg[0] <= 4'd0;
        time_reg[1] <= 4'd0;
        time_reg[2] <= 4'd6;
        time_reg[3] <= 4'd0;
    end else if (time_reg[0] == 4'd0 &&
                 time_reg[1] == 4'd0 &&
                 time_reg[2] == 4'd0 &&
                 time_reg[3] == 4'd0   ) begin
        time_reg[0] <= 4'd0;
        time_reg[1] <= 4'd0;
        time_reg[2] <= 4'd6;
        time_reg[3] <= 4'd0;
    end else begin
        time_reg[0] <= next0;
        time_reg[1] <= next1;
        time_reg[2] <= next2;
        time_reg[3] <= next3;
    end
end

endmodule