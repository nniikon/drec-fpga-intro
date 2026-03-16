module fp16add (
    input wire [15:0] i_a,
    input wire [15:0] i_b,
    output reg [15:0] o_res
);

wire        sign_a = i_a[15];
wire [4:0]  exp_a  = i_a[14:10];
// without the 3 extra bits of accuracy the final error gets to >2ulp
wire [13:0] mant_a = {1'b1, i_a[9:0], 3'b000}; 

wire        sign_b = i_b[15];
wire [4:0]  exp_b  = i_b[14:10];
wire [13:0] mant_b = {1'b1, i_b[9:0], 3'b000};

reg         sign_res;
reg [4:0]   exp_res;

wire is_a_denorm = (exp_a == 0);
wire is_b_denorm = (exp_b == 0);

always @(*) begin
    reg                 sign_bigger;
    reg          [4:0]  exp_bigger;
    reg unsigned [13:0] mant_bigger;

    reg                 sign_smaller;
    reg          [4:0]  exp_smaller;
    reg unsigned [13:0] mant_smaller;

    reg signed   [5:0]  exp_difference;
    reg signed   [15:0] mant_sum;

    reg signed   [14:0] mant_bigger_signed;
    reg signed   [14:0] mant_smaller_signed;

    reg          [4:0]  lzc_count;

    exp_difference = exp_a - exp_b;

    if (exp_difference >= 0) begin
        sign_bigger = sign_a;
        exp_bigger = exp_a;
        mant_bigger = mant_a;

        sign_smaller = sign_b;
        exp_smaller = exp_b;
        mant_smaller = mant_b;
    end
    else begin
        sign_bigger = sign_b;
        exp_bigger = exp_b;
        mant_bigger = mant_b;

        sign_smaller = sign_a;
        exp_smaller = exp_a;
        mant_smaller = mant_a;

        exp_difference = -exp_difference;
    end

    mant_smaller = mant_smaller >> exp_difference;

    if (sign_bigger) begin
        mant_bigger_signed = -mant_bigger;
    end
    else begin
        mant_bigger_signed = mant_bigger;
    end

    if (sign_smaller) begin
        mant_smaller_signed = -mant_smaller;
    end
    else begin
        mant_smaller_signed = mant_smaller;
    end

    mant_sum = mant_bigger_signed + mant_smaller_signed;

    if (mant_sum[15] == 1) begin
        mant_sum = -mant_sum;
        sign_res = 1'b1;
    end
    else begin
        sign_res = 1'b0;
    end

    casez (mant_sum)
        16'b0_1???_????_????_???: lzc_count = 5'd0;
        16'b0_01??_????_????_???: lzc_count = 5'd1;
        16'b0_001?_????_????_???: lzc_count = 5'd2;
        16'b0_0001_????_????_???: lzc_count = 5'd3;
        16'b0_0000_1???_????_???: lzc_count = 5'd4;
        16'b0_0000_01??_????_???: lzc_count = 5'd5;
        16'b0_0000_001?_????_???: lzc_count = 5'd6;
        16'b0_0000_0001_????_???: lzc_count = 5'd7;
        16'b0_0000_0000_1???_???: lzc_count = 5'd8;
        16'b0_0000_0000_01??_???: lzc_count = 5'd9;
        16'b0_0000_0000_001?_???: lzc_count = 5'd10;
        16'b0_0000_0000_0001_???: lzc_count = 5'd11;
        16'b0_0000_0000_0000_1??: lzc_count = 5'd12;
        16'b0_0000_0000_0000_01?: lzc_count = 5'd13;
        16'b0_0000_0000_0000_001: lzc_count = 5'd14;
        16'b0_0000_0000_0000_000: lzc_count = 5'd15;
        default:                  lzc_count = 5'd16;
    endcase

    if (lzc_count == 5'd0) begin
        mant_sum = mant_sum >> 1;
        exp_res = exp_bigger + 1;
    end
    else if (lzc_count == 5'd15) begin
        mant_sum = 16'b0;
        exp_res  =  5'b0;
    end
    else begin
        mant_sum = mant_sum << (lzc_count - 1);
        exp_res = exp_bigger - (lzc_count - 1);
    end

    if (is_a_denorm || is_b_denorm) begin
        // DTZ + FTZ
        o_res = {sign_res, 15'b0};
    end
    else begin
        o_res = {sign_res, exp_res[4:0], mant_sum[12:3]};
    end

end

endmodule