module fp16mul (
    input wire [15:0] i_a,
    input wire [15:0] i_b,
    output reg [15:0] o_res
);

wire        sign_a = i_a[15];
wire [4:0]   exp_a = i_a[14:10];
wire [10:0] mant_a = {1'b1, i_a[9:0]}; 

wire        sign_b = i_b[15];
wire [4:0]   exp_b = i_b[14:10];
wire [10:0] mant_b = {1'b1, i_b[9:0]};

reg        sign_res;
reg [4:0]   exp_res;
reg [10:0] mant_res;

reg        [21:0] mant_mul;
reg signed [5:0]  exp_sum;

wire is_a_denorm = (exp_a == 0);
wire is_b_denorm = (exp_b == 0);

always @(*) begin

    sign_res = sign_a ^ sign_b;

    mant_mul = mant_a * mant_b;
    exp_sum = exp_a + exp_b - 15;

    // if mant_mul in [1, 4)
    if (mant_mul[21] == 1) begin
        exp_sum = exp_sum + 1;
        mant_mul = mant_mul >> 1;
    end

    if (is_a_denorm || is_b_denorm || exp_sum <= 0) begin
        // DTZ + FTZ
        o_res = {sign_res, 15'b0};
    end
    else if (exp_sum >= 'b11111) begin
        // inf
        o_res = {sign_res, 5'b11111, 10'b0};
    end
    else begin
        // normal
        o_res = {sign_res, exp_sum[4:0], mant_mul[19:10]};
    end
end

endmodule