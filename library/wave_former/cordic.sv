//! example
module CORDIC
#(
    parameter unsigned PIPELINE_STAGES = 15,
    parameter unsigned XY_WIDTH = 16, // should be 2 digit more than target inputs
    parameter unsigned Z_WIDTH = 16,
    parameter string   MODE = "rotation"
) (
    input  logic clk,
    input  logic en,
    input  logic rst,

    input  logic                valid_in,
    input  logic [XY_WIDTH-1:0] x_in,
    input  logic [XY_WIDTH-1:0] y_in,
    input  logic [Z_WIDTH-1:0]  z_in,

    output logic                valid_out,
    output logic [XY_WIDTH-1:0] x_out,
    output logic [XY_WIDTH-1:0] y_out,
    output logic [Z_WIDTH-1:0]  z_out
);

    generate        
        if (MODE == "rotation")
        begin
            rotate_cordic #(
                .PIPELINE_STAGES(PIPELINE_STAGES),
                .XY_WIDTH(XY_WIDTH),
                .Z_WIDTH(Z_WIDTH)
            ) ROTATION_CORDIC (
                .clk(clk),
                .en(en),
                .rst(rst),
                .valid_in(valid_in),
                .x_in(x_in),
                .y_in(y_in),
                .z_in(z_in),
                .valid_out(valid_out),
                .x_out(x_out),
                .y_out(y_out),
                .z_out(z_out)
            );
        end
        else if (MODE == "vectoring")
        begin
            vector_cordic #(
                .PIPELINE_STAGES(PIPELINE_STAGES),
                .XY_WIDTH(XY_WIDTH),
                .Z_WIDTH(Z_WIDTH)
            ) VECTORING_CORDIC (
                .clk(clk),
                .en(en),
                .rst(rst),
                .valid_in(valid_in),
                .x_in(x_in),
                .y_in(y_in),
                .z_in(z_in),
                .valid_out(valid_out),
                .x_out(x_out),
                .y_out(y_out),
                .z_out(z_out)
            );
        end
        else
        begin
            // $error("invalid CORDIC MODE parameter (available: \"rotation\", \"vectoring\")");
            illegal_parameter_condition_triggered_will_instantiate_an non_existing_module();
        end
    endgenerate;

endmodule