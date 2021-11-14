module cdc_array_single #(
    parameter DEST_SYNC_FF = 4,    // integer; range: 2-10
    parameter SIM_ASSERT_CHK = 0,  // integer; 0=disable simulation messages, 1=enable simulation messages
    parameter SRC_INPUT_REG = 1,   // integer; 0=do not register input, 1=register input
    parameter WIDTH = 2,           // integer; range: 2-1024
    parameter PLATFORM = "xilinx"  // string; "sim"=simulation, "xilinx"=xpm_cdc_array_single, "another"=wire
) (
    input  logic             src_clk, // optional; required when SRC_INPUT_REG = 1
    input  logic             dest_clk,
    input  logic [WIDTH-1:0] src_in,
    output logic [WIDTH-1:0] dest_out
);
    logic [WIDTH-1:0] input_data;
    generate
        if (PLATFORM == "sim")
        begin
            if (SRC_INPUT_REG == 1)
            begin
                dffenr #(WIDTH) input_reg (src_clk, 1, 0, src_in, input_data);
            end
            else
            begin
                assign input_data = src_in;
            end
            delay_line 
            #(
                .TYPE(logic [WIDTH-1:0]),
                .DELAY(DEST_SYNC_FF)
            )
            delay
            (
                .clk(dest_clk),
                .en(1),
                .din(input_data),
                .dout(dest_out)
            );
        end
        else if (PLATFORM == "xilinx")
        begin
            xpm_cdc_array_single #(
                .DEST_SYNC_FF (DEST_SYNC_FF), // integer; range: 2-10
                .SIM_ASSERT_CHK (SIM_ASSERT_CHK), // integer; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG (SRC_INPUT_REG), // integer; 0=do not register input, 1=register input
                .WIDTH (WIDTH) // integer; range: 2-1024
            ) xpm_cdc_array_single_inst (
                .src_clk (src_clk), // optional; required when SRC_INPUT_REG = 1
                .src_in (src_in),
                .dest_clk (dest_clk),
                .dest_out (dest_out)
            );
        end
        else
        begin
            assign dest_out = src_in;
        end
    endgenerate

endmodule