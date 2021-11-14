module cordic_stage 
#(
    parameter unsigned XY_WIDTH = 16,
    parameter unsigned Z_WIDTH = 16
)(
    input  logic signed   [Z_WIDTH-1:0]  alpha,
    input  logic unsigned [$clog2(XY_WIDTH)-1:0] stage,
    
    input  logic d,

    input  logic signed   [XY_WIDTH-1:0] x_in,
    input  logic signed   [XY_WIDTH-1:0] y_in,
    input  logic signed   [Z_WIDTH-1:0]  z_in,

    output logic [XY_WIDTH-1:0] x_out,
    output logic [XY_WIDTH-1:0] y_out,
    output logic [Z_WIDTH-1:0]  z_out
);
    always_comb
    begin
        if (d)
        begin
            x_out = x_in + (y_in >>> stage);
            y_out = y_in - (x_in >>> stage);
            z_out = z_in + alpha;
        end 
        else begin
            x_out = x_in - (y_in >>> stage);
            y_out = y_in + (x_in >>> stage);
            z_out = z_in - alpha;
        end
    end        
endmodule

