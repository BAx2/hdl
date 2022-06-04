// verilog wrapper 
module Dct2 #(
    parameter ImgWidth = 1280
) (
    input   wire            s_axis_aclk,
    input   wire            s_axis_areset,

    input   wire            s_axis_tvalid,
    output  wire            s_axis_tready,
    input   wire    [00:0]  s_axis_tuser,
    input   wire            s_axis_tlast,
    input   wire    [63:0]  s_axis_tdata,

    output  wire            m_axis_tvalid,
    input   wire            m_axis_tready,
    output  wire    [00:0]  m_axis_tuser,
    output  wire            m_axis_tlast,
    output  wire    [63:0]  m_axis_tdata
);
    localparam DinWidth = 8;
    localparam DoutWidth = 16;
    localparam Type = "dct";

    wire                        int_valid;
    wire                        int_ready;
    wire                        int_sof;
    wire                        int_eol;
    wire   [8*DoutWidth-1:0]    int_data;

    Dct2D #(
        .ImgWidth   (ImgWidth),
        .DinWidth   (DinWidth),
        .DoutWidth  (DoutWidth),
        .Type       (Type)
    ) Dct2DInst (
        .clk_i      (s_axis_aclk),
        .rst_i      (s_axis_areset),

        .s_valid_i  (s_axis_tvalid),
        .s_ready_o  (s_axis_tready),
        .s_sof_i    (s_axis_tuser),
        .s_eol_i    (s_axis_tlast),
        .s_data_i   (s_axis_tdata),

        .m_valid_o  (int_valid),
        .m_ready_i  (int_ready),
        .m_sof_o    (int_sof),
        .m_eol_o    (int_eol),
        .m_data_o   (int_data)
    );

    ParallelToSerial #(
        .Width      (64),
        .N          (2),
        .OutputReg  (1)
    ) SerializerInst (
        .clk_i      (s_axis_aclk),
        .rst_i      (s_axis_areset),
        
        .s_valid_i  (int_valid),
        .s_ready_o  (int_ready),
        .s_sof_i    (int_sof),
        .s_eol_i    (int_eol),
        .s_data_i   (int_data),

        .m_valid_o  (m_axis_tvalid),
        .m_ready_i  (m_axis_tready),
        .m_sof_o    (m_axis_tuser),
        .m_eol_o    (m_axis_tlast),
        .m_data_o   (m_axis_tdata)
    );
endmodule
