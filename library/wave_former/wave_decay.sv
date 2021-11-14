`include "cordic.svh"

module wave_decay 
#(
    parameter STAGES = 10
)(
    input  logic clk,
    input  logic rst,
    input  logic en,

    input  logic signed [15:0] x_offset,
    input  logic signed [15:0] y_offset, 
    input  logic signed [15:0] amplitude,  // Q1.15

    input  logic [15:0] x,
    input  logic [15:0] y,

    output logic signed [15:0] koef        // Q1.15
);

    // koeff = kx * ky
    // kx = cos((x - x_offset) / 640 * pi) * amplitude + (1 - amplitude)
    // ky = cos((y - y_offset) / 640 * pi) * amplitude + (1 - amplitude)

    logic [15:0] kx, ky;

    one_channel_decay #(.STAGES(STAGES)) decay_x (
        .clk(clk),
        .rst(rst),
        .en(en),
        .offset(x_offset),
        .amplitude(amplitude),
        .val(x),
        .koef(kx)
    );

    one_channel_decay #(.STAGES(STAGES)) decay_y (
        .clk(clk),
        .rst(rst),
        .en(en),
        .offset(y_offset),
        .amplitude(amplitude),
        .val(y),
        .koef(ky)
    );

    logic signed [31:0] kxy;
    assign kxy = kx * ky;
    dffenr #(16) koef_reg (clk, en, rst, kxy >> 15, koef);

endmodule

module one_channel_decay
#(
    parameter STAGES = 10,
    parameter logic signed [15:0] OMEGA = $rtoi(2.0**15 / 640 * 2.0**9) // Q7.9
) (
    input  logic clk,
    input  logic rst,
    input  logic en,
    
    input  logic signed [15:0] offset,
    input  logic signed [15:0] amplitude, // Q1.15
    input  logic [15:0] val,

    output logic signed [15:0] koef       // Q1.15
);
    // k = cos((val - offset) * omega) * A + (1-A)

    // pi = 2**(Z_WIDTH-1);
    // omega = pi / 640 
    // for Z_WIDTH = 2**15
    // omega = pi / 640;

    logic signed [15:0] decay_offset;
    dffenr #(16) decay_offset_reg (clk, en, rst, (16'h7fff - amplitude), decay_offset);

    logic signed [15:0] offset_val;
    dffenr #(16) offset_val_reg (clk, en, rst, (val - offset), offset_val);
    
    logic signed [15:0] angle;
    logic signed [31:0] angle_ext;
    assign angle_ext = offset_val * OMEGA;
    dffenr #(16) angle_reg (clk, en, rst, angle_ext >>> 9, angle);

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
    
    dffenr #(16) koef_reg (clk, en, rst, (scale_cos + decay_offset), koef);

endmodule