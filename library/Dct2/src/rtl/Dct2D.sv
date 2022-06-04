module Dct2D #(
    parameter ImgWidth = 1280,
    parameter DinWidth = 7,
    parameter DoutWidth = 14,
    parameter Type = "dct" // "idct"
) (
    input   logic                           clk_i,
    input   logic                           rst_i,
    
    input   logic                           s_valid_i,
    output  logic                           s_ready_o,
    input   logic                           s_sof_i,
    input   logic                           s_eol_i,
    input   logic   [0:7][DinWidth-1:0]     s_data_i,

    output  logic                           m_valid_o,
    input   logic                           m_ready_i,
    output  logic                           m_sof_o,
    output  logic                           m_eol_o,
    output  logic   [0:7][DoutWidth-1:0]    m_data_o
);
    localparam RowDctWidth = DinWidth + 4;
    localparam ConvertionsPerLine = ImgWidth / 8;
    localparam BramAddrWidth = $clog2(ConvertionsPerLine);

    logic                               row_valid;
    logic                               row_ready;
    logic                               row_sof;
    logic                               row_eol;
    logic   [0:7][RowDctWidth-1:0]      row_data;

    logic   [0:7][RowDctWidth-1:0]      col_data;
    logic                               col_valid;
    logic                               col_ready;
    logic                               col_sof;
    logic                               col_eol;

    logic   [0:7][DoutWidth-1:0]        dct_data;
    logic                               dct_valid;
    logic                               dct_ready;

    logic                               m_sof;
    logic                               m_eol;
    logic                               m_valid;
    logic                               m_ready;
    logic   [0:7][DoutWidth-1:0]        m_data;

    assign m_data_o = m_data;
    assign m_valid_o = m_valid;
    assign m_ready = m_ready_i;
    assign m_eol_o = m_eol;
    assign m_sof_o = m_sof;

    Dct1D #(
        .DinWidth(DinWidth),
        .DoutWidth(RowDctWidth),
        .InputReg(1),
        .OutputReg(1),
        .IntWidth(16),
        .IntPoint(12)
    ) RowDctInst (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_valid_i(s_valid_i),
        .s_ready_o(s_ready_o),
        .s_sof_i(s_sof_i),
        .s_eol_i(s_eol_i),
        .s_data_i(s_data_i),

        .m_valid_o(row_valid),
        .m_ready_i(row_ready),
        .m_sof_o(row_sof),
        .m_eol_o(row_eol),
        .m_data_o(row_data)
    );

    DctBuffer #(
        .DinWidth(RowDctWidth),
        .ConvertionsPerLine(ConvertionsPerLine)
    ) DctLineBuffer (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .busy_o(),
    
        .s_data_i(row_data),
        .s_sof_i(row_sof),
        .s_eol_i(row_eol),
        .s_valid_i(row_valid),
        .s_ready_o(row_ready),

        .m_valid_o(col_valid),
        .m_ready_i(col_ready),
        .m_sof_o(col_sof),
        .m_eol_o(col_eol),
        .m_data_o(col_data)
    );

    Dct1D #(
        .DinWidth(RowDctWidth),
        .DoutWidth(DoutWidth),
        .InputReg(1),
        .OutputReg(1),
        .IntWidth(16),
        .IntPoint(12),
        .InputSigned(1)
    ) ColDctInst (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_valid_i(col_valid),
        .s_ready_o(col_ready),
        .s_sof_i(col_sof),
        .s_eol_i(col_eol),
        .s_data_i(col_data),

        .m_valid_o(dct_valid),
        .m_ready_i(dct_ready),
        .m_sof_o(m_sof),
        .m_eol_o(m_eol),
        .m_data_o(dct_data)
    );

    /// TODO: Add transpose unit
    always_comb begin
        for (int i = 0; i < 8; i++) begin
            // output point position = input point position
            // m_data[i] = dct_data[i] / 8;

            // output point position = input point position + 3
            m_data[i] = dct_data[i];
        end
    end

    assign m_valid = dct_valid;
    assign dct_ready = m_ready;

endmodule
