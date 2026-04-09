module clkdiv (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] i_select,
    output reg        o_clk 
);

    localparam [12:0] MAX_9600   = 13'd5207;
    localparam [12:0] MAX_38400  = 13'd1301;
    localparam [12:0] MAX_115200 = 13'd433;

    reg [12:0] counter;
    reg [12:0] current_max;

    always @(*) begin
        case (i_select)
            2'b00:   current_max = MAX_9600;
            2'b01:   current_max = MAX_38400;
            2'b10:   current_max = MAX_115200;
            2'b11:   current_max = MAX_9600;
            default: current_max = MAX_9600;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 13'd0;
            o_clk    <= 1'b0;
        end else begin
            if (counter >= current_max) begin
                counter <= 13'd0;
                o_clk    <= 1'b1;
            end else begin
                counter <= counter + 1'b1;
                o_clk    <= 1'b0;
            end
        end
    end

endmodule