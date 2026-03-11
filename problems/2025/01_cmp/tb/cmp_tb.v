`timescale 1ns/1ps

module cmp_tb #(
    parameter WIDTH = 32
);

localparam N_TESTS = 1000;

reg [WIDTH-1:0] rs1;
reg [WIDTH-1:0] rs2;
reg [2:0]    funct3;

reg       res;
reg exception;

reg       res_ref;
reg exception_ref;

rv32i_cmp #(
    .WIDTH(WIDTH)
) rv32i_cmp_inst (
    .i_rs1(rs1),
    .i_rs2(rs2),
    .i_funct3(funct3),
    .o_res(res),
    .o_exception(exception)
);

integer failed = 0;
integer test_num = 0;

initial begin

for (integer i = 0; i < N_TESTS; i = i + 1) begin
    funct3 = 3'b000; // beq
    rs1 = $urandom;
    rs2 = rs1;
    #10;
    if ((res != (rs1 == rs2)) || (exception != exception_ref)) begin
        failed = failed + 1;
        $display("FAIL Test %0d: f3:%h rs1:%h rs2:%h | Expected: rd:%h exc:%b | Got: rd:%h exc:%b", 
                 test_num, funct3, rs1, rs2, res_ref, exception_ref, res, exception);
    end

    test_num = test_num + 1;
end
for (integer i = 0; i < N_TESTS; i = i + 1) begin
    funct3 = 3'b000; // beq
    rs1 = $urandom;
    rs2 = $urandom;
    #10;
    if ((res != (rs1 == rs2)) || (exception != exception_ref)) begin
        failed = failed + 1;
        $display("FAIL Test %0d: f3:%h rs1:%h rs2:%h | Expected: rd:%h exc:%b | Got: rd:%h exc:%b", 
                 test_num, funct3, rs1, rs2, res_ref, exception_ref, res, exception);
    end

    test_num = test_num + 1;
end

for (integer i = 0; i < N_TESTS; i = i + 1) begin
    funct3 = 3'b001; // bne
    rs1 = $urandom;
    rs2 = rs1;
    #10;
    if ((res != (rs1 != rs2)) || (exception != exception_ref)) begin
        failed = failed + 1;
        $display("FAIL Test %0d: f3:%h rs1:%h rs2:%h | Expected: rd:%h exc:%b | Got: rd:%h exc:%b", 
                 test_num, funct3, rs1, rs2, res_ref, exception_ref, res, exception);
    end

    test_num = test_num + 1;
end

for (integer i = 0; i < N_TESTS; i = i + 1) begin
    funct3 = 3'b001; // bne
    rs1 = $urandom;
    rs2 = $urandom;
    #10;
    if ((res != (rs1 != rs2)) || (exception != exception_ref)) begin
        failed = failed + 1;
        $display("FAIL Test %0d: f3:%h rs1:%h rs2:%h | Expected: rd:%h exc:%b | Got: rd:%h exc:%b", 
                 test_num, funct3, rs1, rs2, res_ref, exception_ref, res, exception);
    end

    test_num = test_num + 1;
end

for (integer i = 0; i < N_TESTS; i = i + 1) begin
    funct3 = 3'b100; // blt
    rs1 = $urandom;
    rs2 = $urandom;
    #10;
    if ((res != ($signed(rs1) < $signed(rs2))) || (exception != exception_ref)) begin
        failed = failed + 1;
        $display("FAIL Test %0d: f3:%h rs1:%h rs2:%h | Expected: rd:%h exc:%b | Got: rd:%h exc:%b", 
                 test_num, funct3, rs1, rs2, res_ref, exception_ref, res, exception);
    end

    test_num = test_num + 1;
end

for (integer i = 0; i < N_TESTS; i = i + 1) begin
    funct3 = 3'b101; // bge
    rs1 = $urandom;
    rs2 = $urandom;
    #10;
    if ((res != ($signed(rs1) >= $signed(rs2))) || (exception != exception_ref)) begin
        failed = failed + 1;
        $display("FAIL Test %0d: f3:%h rs1:%h rs2:%h | Expected: rd:%h exc:%b | Got: rd:%h exc:%b", 
                 test_num, funct3, rs1, rs2, res_ref, exception_ref, res, exception);
    end

    test_num = test_num + 1;
end

for (integer i = 0; i < N_TESTS; i = i + 1) begin
    funct3 = 3'b110; // bltu
    rs1 = $urandom;
    rs2 = $urandom;
    #10;
    if ((res != ($unsigned(rs1) < $unsigned(rs2))) || (exception != exception_ref)) begin
        failed = failed + 1;
        $display("FAIL Test %0d: f3:%h rs1:%h rs2:%h | Expected: rd:%h exc:%b | Got: rd:%h exc:%b", 
                 test_num, funct3, rs1, rs2, res_ref, exception_ref, res, exception);
    end

    test_num = test_num + 1;
end

for (integer i = 0; i < N_TESTS; i = i + 1) begin
    funct3 = 3'b111; // bgeu
    rs1 = $urandom;
    rs2 = $urandom;
    #10;
    if ((res != ($unsigned(rs1) >= $unsigned(rs2))) || (exception != exception_ref)) begin
        failed = failed + 1;
        $display("FAIL Test %0d: f3:%h rs1:%h rs2:%h | Expected: rd:%h exc:%b | Got: rd:%h exc:%b", 
                 test_num, funct3, rs1, rs2, res_ref, exception_ref, res, exception);
    end

    test_num = test_num + 1;
end

if (failed == 0) begin
    $display("SUCCESS: [%0d] tests passed!", test_num);
end else begin
    $display("FAIL: [%0d]/[%0d] tests failed.", failed, test_num);
end

end

endmodule