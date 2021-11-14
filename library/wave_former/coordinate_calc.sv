module coordinate_calc (
    input  logic        clk,
    input  logic        rst,

    input  logic        valid,
    input  logic        ready,
    input  logic        sof,
    input  logic        eol,

    output logic [15:0] x,
    output logic [15:0] y
);

    logic [15:0] x_cnt;
    logic [15:0] y_cnt;
    
    always_ff @(posedge clk)
    begin
        if (rst)
        begin
            x_cnt <= 0;
            y_cnt <= 0;
        end
        else if (ready & valid)
        begin
            if (sof)
            begin
                x_cnt <= 0;
                y_cnt <= 0;                
            end
            else if (eol)
            begin
                x_cnt <= 0;
                y_cnt <= y_cnt + 1;                
            end
            else
            begin
                x_cnt <= x_cnt + 1;
            end
        end
    end

    assign x = x_cnt;
    assign y = y_cnt;

endmodule