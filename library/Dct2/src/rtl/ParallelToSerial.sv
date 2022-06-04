module ParallelToSerial #(
    parameter Width = 64,
    parameter N = 2,
    parameter OutputReg = 1
) (
    input   logic                      clk_i,
    input   logic                      rst_i,
    
    input   logic                      s_valid_i,
    output  logic                      s_ready_o,
    input   logic                      s_sof_i,
    input   logic                      s_eol_i,
    input   logic   [0:N-1][Width-1:0] s_data_i,

    output  logic                      m_valid_o,
    input   logic                      m_ready_i,
    output  logic                      m_sof_o,
    output  logic                      m_eol_o,
    output  logic          [Width-1:0] m_data_o
);
    localparam CntWidth = $clog2(N);

    logic                      s_valid;
    logic                      s_ready;
    logic                      s_sof;
    logic                      s_eol;
    logic   [0:N-1][Width-1:0] s_data;

    logic [1:0] s_sof_eol;
    AxisReg #(
        .DataWidth($bits(s_data_i)),
        .Transperent(0),
        .SideDataWidth(2),
        .Pipelined(1)
    ) InputRegInst (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_side_data_i({s_sof_i, s_eol_i}),
        .s_data_i(s_data_i),
        .s_valid_i(s_valid_i),
        .s_ready_o(s_ready_o),
        
        .m_side_data_o(s_sof_eol),
        .m_data_o(s_data),
        .m_valid_o(s_valid),
        .m_ready_i(s_ready)
    );
    assign s_sof = s_sof_eol[1];
    assign s_eol = s_sof_eol[0];

    logic m_valid;
    logic m_ready;
    logic m_sof;
    logic m_eol;

    logic next_output;
    assign next_output = m_valid & m_ready;

    logic [CntWidth-1:0] cnt;
    always_ff @(posedge clk_i) begin
        if (rst_i | !s_valid) begin
            cnt <= 0;
        end else begin
            if (next_output) begin
                if (cnt == N-1)
                    cnt <= 0;
                else 
                    cnt <= cnt + 1;
            end
        end
    end

    logic [1:0] m_sof_eol;
    assign s_ready = (cnt == N-1) & next_output; 
    assign m_sof_o = m_sof_eol[1];
    assign m_eol_o = m_sof_eol[0];
    assign m_valid = s_valid;
    assign m_sof = (cnt == 0) & s_sof;
    assign m_eol = (cnt == N-1) & s_eol;

    AxisReg #(
        .DataWidth(Width),
        .Transperent(!OutputReg),
        .Pipelined(1),
        .SideDataWidth(2)
    ) OutputRegInst (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_data_i(s_data[cnt]),
        .s_side_data_i({ m_sof, m_eol }),
        .s_valid_i(m_valid),
        .s_ready_o(m_ready),

        .m_ready_i(m_ready_i),
        .m_valid_o(m_valid_o),
        .m_side_data_o(m_sof_eol),
        .m_data_o(m_data_o)
    );

endmodule
