`include "cordic.svh"

module coordinate_recalc 
#(
    parameter STAGES = 10
)(
    input  logic clk,
    input  logic rst,
    input  logic en,

    input  logic [15:0] x_offset,
    input  logic [15:0] y_offset, 

    input  logic [15:0] x,
    input  logic [15:0] y,

    output logic [15:0] x0
);
    
    // x0 = sqrt((x - x_offset)^2 + (y - y_offset)^2);

    parameter logic [13:0] SCALE = $rtoi(2.0**14/CORDIC_SCALE_K);

    logic [15:0] cordic_radius;
    logic [31:0] radius;

    CORDIC
    #(
        .PIPELINE_STAGES(STAGES),
        .XY_WIDTH(16),
        .Z_WIDTH(16),
        .MODE("vectoring")
    ) RADIUS (
        .clk(clk),
        .en(en),
        .rst(rst),

        .valid_in(1'b1),
        .x_in(x - x_offset),
        .y_in(y - y_offset),
        .z_in(16'b0),

        .valid_out(),
        .x_out(cordic_radius),
        .y_out(),
        .z_out()
    );

    always_ff @(posedge clk)
    begin
        if (rst)
        begin
            radius <= 0;
        end
        else if (en)
        begin
            radius <= cordic_radius * SCALE;
        end
    end

    assign x0 = radius >> 14;

endmodule