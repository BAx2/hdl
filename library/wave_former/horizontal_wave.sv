`include "cordic.svh"

module horizontal_wave
#(
    parameter STAGES = 10
) (
    input  logic        clk,
    input  logic        rst,
    input  logic        en,

    input  logic signed [15:0] phase,
    input  logic        [15:0] x, 
    input  logic signed [15:0] omega,      // Q12.4
    input  logic signed [15:0] amplitude,  // Q1.15

    output logic signed [15:0] koef        // Q1.15
);
    // koeff = sin(omega * x + phase) * amplitude + (1-amplitude)

    logic signed [15:0] angle;
    logic signed [31:0] angle_ext;
    assign angle_ext = (omega * x);
    dffenr #(16) angle_reg (clk, en, rst, (angle_ext >>> 4) + phase, angle);
    // dffenr #(16) angle_reg (clk, en, rst, (angle_ext >>> 15) + phase, angle);
    
    logic signed [15:0] cos;
    CORDIC 
    #(
        .PIPELINE_STAGES(STAGES),
        .XY_WIDTH(16),
        .Z_WIDTH(16),
        .MODE("rotation")
    ) SINE (
        .clk(clk),
        .en(en),
        .rst(rst),

        .valid_in(1),
        .x_in(2.0 ** 15 / CORDIC_SCALE_K - 'hf),
        .y_in(0),
        .z_in(angle),

        .valid_out(),
        .x_out(cos),
        .y_out(),
        .z_out()
    );


    logic [15:0] scale_cos;
    logic signed [31:0] scale_cos_ext;
    assign scale_cos_ext = cos * amplitude;
    dffenr #(16) scale_reg (clk, en, rst, scale_cos_ext >> 15, scale_cos);
    
    logic signed [15:0] wave_offset;
    dffenr #(16) wave_offset_reg (clk, en, rst, (16'h7fff - amplitude), wave_offset);

    dffenr #(16) koef_reg (clk, en, rst, (scale_cos + wave_offset), koef);
    
endmodule