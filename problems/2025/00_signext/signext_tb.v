`timescale 1ns/1ps

module signext_tb;

localparam WIDTH_IN  = 12;
localparam WIDTH_OUT = 32;

reg  [WIDTH_IN-1:0] in;
reg  [WIDTH_OUT-1:0] out_ref;
wire [WIDTH_OUT-1:0] out_struct;
wire [WIDTH_OUT-1:0] out_behav;

sign_extender_struct #(
    .WIDTH_IN(WIDTH_IN),
    .WIDTH_OUT(WIDTH_OUT)
) sign_extender_struct_inst (
    .i_int(in),
    .o_int(out_struct)
);

sign_extender_behav #(
    .WIDTH_IN(WIDTH_IN),
    .WIDTH_OUT(WIDTH_OUT)
) sign_extender_behav_inst (
    .i_int(in),
    .o_int(out_behav)
);

integer i = 0;
integer failed = 0;
integer file_handle;
integer scan_count;

initial begin
    $dumpvars;
    file_handle = $fopen("tests.txt", "r");

    if (file_handle == 0) begin
        $display("ERROR: run `python gen_tests.txt`");
        $finish;
    end

    while (!$feof(file_handle)) begin
        scan_count = $fscanf(file_handle, "%x %x\n", in, out_ref);

        if (scan_count == 2) begin
            #1; 

            if (out_struct !== out_ref) begin
                $display("Struct Error [%0d] | Input: %h | Expected: %h | Got: %h", i, in, out_ref, out_struct);
                failed = failed + 1;
            end

            if (out_behav !== out_ref) begin
                $display("Behav Error  [%0d] | Input: %h | Expected: %h | Got: %h", i, in, out_ref, out_behav);
                failed = failed + 1;
            end

            i = i + 1;
        end
    end

    $fclose(file_handle);

    if (failed == 0) begin
        $display("SUCCESS: [%0d] tests passed", i);
    end else begin
        $display("FAIL: [%0d]/[%0d] tests failed", failed, i);
    end

    $finish;
end

endmodule