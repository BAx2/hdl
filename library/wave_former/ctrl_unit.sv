module ctrl_unit (
    input   logic           clk,
    input   logic           reset,

    input   logic           s_valid,   // valid
    input   logic           delay_valid,    
    input   logic           m_ready,

    output  logic           enable,
    output  logic           s_ready,
    output  logic           m_valid
);

    always_comb
    begin
        s_ready = m_ready;
        enable = m_ready;
    end

endmodule