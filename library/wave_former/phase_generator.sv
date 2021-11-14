module phase_generator 
(
    input  logic        clk,
    input  logic        rst,
    input  logic        enable,
    input  logic [15:0] phase_inc,
    output logic [15:0] phase
);
    always_ff @(posedge clk)
    begin
        if (rst)
            phase = 0;
        else if (enable)
            phase = phase + phase_inc;
    end

endmodule