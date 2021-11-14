module fix_mult_sign_1_15 (
    input  logic               clk,
    input  logic               en,
    input  logic               rst,
    input  logic signed [15:0] a,
    input  logic signed [15:0] b,
    output logic signed [15:0] res
);
    logic signed [31:0] res_ext;
    assign res_ext = a * b;
    dffenr common_k_reg (clk, en, rst, res_ext >>> 15, res);
endmodule