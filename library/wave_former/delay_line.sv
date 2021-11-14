module delay_line 
#(
    parameter type TYPE = logic[15:0],
    parameter      DELAY = 10
)(
    input   logic clk,
    input   logic en,
    input   TYPE  din,
    output  TYPE  dout
);

    TYPE delay [DELAY:0];
    assign delay[0] = din;

    always_ff @(posedge clk)
    begin
        if (en)
        begin
            delay[DELAY:1] <= delay[DELAY-1:0];
        end
    end

    assign dout = delay[DELAY];
    
endmodule