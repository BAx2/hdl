module rotate_cordic
#(
    parameter unsigned PIPELINE_STAGES = 15,
    parameter unsigned XY_WIDTH = 16,
    parameter unsigned Z_WIDTH = 16
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

    typedef struct packed
    {
        logic signed [XY_WIDTH-1:0] x;
        logic signed [XY_WIDTH-1:0] y;
        logic signed [Z_WIDTH-1:0]  z;
        logic valid;
        logic swap_xy;
        logic sign_x;    
    } stage_t;

    stage_t stage_reg  [0:PIPELINE_STAGES];
    stage_t stage_comb [0:PIPELINE_STAGES];

    stage_t input_vals, input_reg;
    assign input_vals = {
        x_in,
        y_in,
        z_in,
        valid_in,
        1'b0,
        1'b0
    };
    dffenr #($bits(stage_t)) INPUT_REG (clk, en, rst, input_vals, input_reg);  

    localparam integer pi_2 = 2**(Z_WIDTH-2);

    always_comb
    begin
        stage_comb[0].x = input_reg.x;
        stage_comb[0].y = input_reg.y;
        stage_comb[0].sign_x = input_reg.z[Z_WIDTH-1];
        stage_comb[0].valid = input_reg.valid;
        
        if (input_reg.z > pi_2)
        begin
            stage_comb[0].swap_xy = 1;
            stage_comb[0].z = input_reg.z - pi_2;
        end
        else if (input_reg.z < -pi_2)
        begin
            stage_comb[0].swap_xy = 1;
            stage_comb[0].z = input_reg.z + pi_2;
        end
        else
        begin
            stage_comb[0].swap_xy = 0;
            stage_comb[0].z = input_reg.z;
        end
    end

    genvar i;
    generate
        for (i = 0; i < PIPELINE_STAGES; i++)
        begin
            dffenr #($bits(stage_t)) REG (clk, en, rst, stage_comb[i], stage_reg[i]);

            localparam real angle = $atan(2.0**(-i)) / $acos(-1) * 2**(Z_WIDTH-1);

            logic sign_z;
            assign sign_z = stage_reg[i].z[Z_WIDTH-1];

            cordic_stage #(
                .XY_WIDTH(XY_WIDTH),
                .Z_WIDTH(Z_WIDTH)
            ) STAGE (
                .alpha($rtoi(angle)),
                .stage(i),
                .d(sign_z),
                .x_in(stage_reg[i].x),
                .y_in(stage_reg[i].y),
                .z_in(stage_reg[i].z),
                .x_out(stage_comb[i+1].x),
                .y_out(stage_comb[i+1].y),
                .z_out(stage_comb[i+1].z)
            );
            assign stage_comb[i+1].sign_x = stage_reg[i].sign_x;
            assign stage_comb[i+1].swap_xy = stage_reg[i].swap_xy;
            assign stage_comb[i+1].valid = stage_reg[i].valid;
        end
    endgenerate;
    dffenr #($bits(stage_t)) OUTPUT_CORDIC_REG (clk, en, rst, stage_comb[PIPELINE_STAGES], stage_reg[PIPELINE_STAGES]);

    always_ff @(posedge clk)
    begin
        stage_t cordic_out;
        cordic_out = stage_reg[PIPELINE_STAGES];
        
        z_out <= cordic_out.z;
        valid_out <= cordic_out.valid;
        if (cordic_out.swap_xy)
        begin
            if (cordic_out.sign_x)
            begin
                y_out <= -cordic_out.x;
                x_out <= cordic_out.y;
            end
            else
            begin        
                x_out <= -cordic_out.y;
                y_out <= cordic_out.x;
            end
        end
        else
        begin
            y_out <= cordic_out.y;
            x_out <= cordic_out.x;        
        end
    end

    
endmodule