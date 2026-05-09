module uart_rx #(
    parameter FREQ = 50_000_000,
    parameter RATE =  2_000_000
) (
    input wire clk,
    input wire rst_n,

    input wire i_rx,

    output wire [7:0] o_data,
    output wire       o_vld
);

reg [7:0] data;
reg rst_cnt;
wire en_cnt;
wire en_half_cnt;
reg [3:0] state, next_state;
reg vld;

reg rx_d, rx_dd;

// ------------------------> t
// rx_dd  |  rx_d  |  i_rx
always @(posedge clk) rx_d  <= i_rx;
always @(posedge clk) rx_dd <= rx_d;

wire is_negedge = (rx_d == 1'b0 && rx_dd == 1'b1);
assign o_vld = vld;
assign o_data = data;

localparam [3:0] IDLE  = {1'b0, 3'd0},
                 START = {1'b0, 3'd1},
                 STOP  = {1'b0, 3'd2},
                 BIT0  = {1'b1, 3'd0},
                 BIT1  = {1'b1, 3'd1},
                 BIT2  = {1'b1, 3'd2},
                 BIT3  = {1'b1, 3'd3},
                 BIT4  = {1'b1, 3'd4},
                 BIT5  = {1'b1, 3'd5},
                 BIT6  = {1'b1, 3'd6},
                 BIT7  = {1'b1, 3'd7};

counter #(
    .CNT_WIDTH  ($clog2(FREQ/RATE)),
    .CNT_LOAD   (0                ),
    .CNT_MAX    (FREQ/RATE-1      )
) cnt (
    .clk        (clk  ),
    .rst_n      (rst_n),
    .i_load     (rst_cnt),
    .o_en       (en_cnt),
    .o_half_en  (en_half_cnt)
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data  <= 8'h00;
        state <= IDLE;
        vld   <= 1'b0;
    end else begin
        state <= next_state;
        vld   <= 1'b0;

        if (state == START) begin
            data <= 8'h00;
        end else if (state[3] == 1'b1 && en_half_cnt) begin
            data[state[2:0]] <= rx_dd;
        end

        if (state == STOP && en_cnt) begin
            vld <= 1'b1;
        end
    end
end

always @(*) begin
    rst_cnt = 1'b0;
    case (state)
        IDLE: begin
            rst_cnt    = is_negedge ? 1'b0  : 1'b1;
            next_state = is_negedge ? START : state;
        end
        START:   next_state = en_cnt ? BIT0 : state;
        BIT0:    next_state = en_cnt ? BIT1 : state;
        BIT1:    next_state = en_cnt ? BIT2 : state;
        BIT2:    next_state = en_cnt ? BIT3 : state;
        BIT3:    next_state = en_cnt ? BIT4 : state;
        BIT4:    next_state = en_cnt ? BIT5 : state;
        BIT5:    next_state = en_cnt ? BIT6 : state;
        BIT6:    next_state = en_cnt ? BIT7 : state;
        BIT7:    next_state = en_cnt ? STOP : state;
        STOP:    next_state = en_cnt ? IDLE : state;
        default: next_state = state;
    endcase
end

endmodule
