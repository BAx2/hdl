module dffenr
#(
    parameter unsigned WIDTH = 16
)(
    input  logic clk,
    input  logic en,
    input  logic rst,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
    always_ff @(posedge clk)
        if (rst)
            q <= 0;
        else if (en)
            q <= d;
endmodule
