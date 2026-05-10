`timescale 1ns/1ps

module alu_tb;

    localparam WIDTH = 32;
    localparam N_TESTS = 1000;

    reg [6:0] funct7;
    reg [2:0] funct3;
    reg [WIDTH-1:0] rs1;
    reg [WIDTH-1:0] rs2;

    wire [WIDTH-1:0] rd;
    wire exception;

    reg [WIDTH-1:0] rd_ref;
    reg exception_ref;

    integer file_handle;
    integer scan_count;
    integer failed = 0;
    integer test_num = 0;

    rv32i_alu #(
        .WIDTH(WIDTH)
    ) rv32i_alu_inst (
        .i_funct7_5(funct7[5]),
        .i_funct3(funct3),
        .i_rs1(rs1),
        .i_rs2(rs2),
        .o_rd(rd),
        .exception(exception)
    );

    initial begin
        file_handle = $fopen("tests.txt", "r");
        if (file_handle == 0) begin
            $display("ERROR: run `python gen_tests.txt`");
            $finish;
        end

        while (!$feof(file_handle)) begin
            scan_count = $fscanf(file_handle, "%x %x %x %x %x %x\n", funct7, funct3, rs1, rs2, rd_ref, exception_ref);

            if (scan_count == 6) begin
                #10;

                if (rd_ref !== rd || exception_ref !== exception) begin
                    $display("FAIL Test %0d: f7:%h f3:%h rs1:%h rs2:%h | Expected: rd:%h exc:%b | Got: rd:%h exc:%b", 
                             test_num, funct7, funct3, rs1, rs2, rd_ref, exception_ref, rd, exception);
                    failed = failed + 1;
                end

                test_num = test_num + 1;
            end
        end

        if (failed == 0) begin
            $display("SUCCESS: [%0d] tests passed!", test_num);
        end else begin
            $display("FAIL: [%0d]/[%0d] tests failed.", failed, test_num);
        end

        $fclose(file_handle);
        $finish;
    end

endmodule