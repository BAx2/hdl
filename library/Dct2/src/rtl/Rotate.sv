module Rotate #(
    parameter Width = 16,
    parameter Point = 8,
    parameter Angle = 0,
    parameter SideDataWidth = 0
) (
    input   logic                           clk_i,
    input   logic                           rst_i,

    output  logic                           s_ready_o,
    input   logic                           s_valid_i,
    input   logic signed    [Width-1:0]     s_x1_i,
    input   logic signed    [Width-1:0]     s_x2_i,
    input   logic   [SideDataWidth-1:0]     s_side_data_i,

    input   logic                           m_ready_i,
    output  logic                           m_valid_o,
    output  logic signed    [Width-1:0]     m_y1_o,
    output  logic signed    [Width-1:0]     m_y2_o,
    output  logic   [SideDataWidth-1:0]     m_side_data_o
);
    localparam Tan = $rtoi($tan(Angle/2) * (1 << Point));
    localparam Sin = $rtoi($sin(Angle) * (1 << Point));

    function logic signed [Width-1:0] Mult;
        input logic signed [Width-1:0] a;
        input logic signed [Width-1:0] b;
    begin
        logic signed [2*Width-1:0] mul;
        mul = a * b;
        Mult = (mul >>> Point);
    end
    endfunction

    function logic signed [Width-1:0] Add;
        input logic signed [Width-1:0] a;
        input logic signed [Width-1:0] b;
    begin
        Add = a + b;
    end
    endfunction

    logic signed [Width-1:0] x1, x2;
    logic [2*Width-1:0] x_data; 
    logic [SideDataWidth-1:0] x_side_data;
    logic x_valid, x_ready;
    assign x2 = x_data[Width-1:0];
    assign x1 = x_data[2*Width-1:Width];

    AxisReg #(
        .DataWidth(2*Width),
        .Transperent(1),
        .SideDataWidth(SideDataWidth),
        .Pipelined(1)
    ) InputReg (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_side_data_i(s_side_data_i),
        .m_side_data_o(x_side_data),

        .s_data_i({s_x1_i, s_x2_i}),
        .s_valid_i(s_valid_i),
        .s_ready_o(s_ready_o),

        .m_data_o(x_data),
        .m_valid_o(x_valid),
        .m_ready_i(x_ready)
    );

    logic signed [Width-1:0] tan1_x1, tan1_x2;
    logic [2*Width-1:0] tan1_data; 
    logic [SideDataWidth-1:0] tan1_side_data;
    logic tan1_valid, tan1_ready;
    assign tan1_x2 = tan1_data[Width-1:0];
    assign tan1_x1 = tan1_data[2*Width-1:Width];
           
    AxisReg #(
        .DataWidth(2*Width),
        .Transperent(0),
        .SideDataWidth(SideDataWidth),
        .Pipelined(0)
    ) Tan1Reg (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_side_data_i(x_side_data),
        .m_side_data_o(tan1_side_data),

        .s_data_i({ Add(x1, Mult(x2, Tan)), x2 }),
        .s_valid_i(x_valid),
        .s_ready_o(x_ready),

        .m_data_o(tan1_data),
        .m_valid_o(tan1_valid),
        .m_ready_i(tan1_ready)
    );


    logic signed [Width-1:0] sin_x1, sin_x2;
    logic [2*Width-1:0] sin_data; 
    logic [SideDataWidth-1:0] sin_side_data;
    logic sin_valid, sin_ready;
    assign sin_x2 = sin_data[Width-1:0];
    assign sin_x1 = sin_data[2*Width-1:Width];
    
    AxisReg #(
        .DataWidth(2*Width),
        .Transperent(0),
        .SideDataWidth(SideDataWidth),
        .Pipelined(0)
    ) SinReg (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_side_data_i(tan1_side_data),
        .m_side_data_o(sin_side_data),

        .s_data_i({ tan1_x1, Add(tan1_x2, -Mult(tan1_x1, Sin)) }),
        .s_valid_i(tan1_valid),
        .s_ready_o(tan1_ready),

        .m_data_o(sin_data),
        .m_valid_o(sin_valid),
        .m_ready_i(sin_ready)
    );

    logic [2*Width-1:0] tan2_data; 
    assign m_y2_o = tan2_data[Width-1:0];
    assign m_y1_o = tan2_data[2*Width-1:Width];

    AxisReg #(
        .DataWidth(2*Width),
        .Transperent(0),
        .SideDataWidth(SideDataWidth),
        .Pipelined(0)
    ) Tan2Reg (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_side_data_i(sin_side_data),
        .m_side_data_o(m_side_data_o),

        .s_data_i({ Add(sin_x1, Mult(sin_x2, Tan)), sin_x2 }),
        .s_valid_i(sin_valid),
        .s_ready_o(sin_ready),

        .m_data_o(tan2_data),
        .m_valid_o(m_valid_o),
        .m_ready_i(m_ready_i)
    );

endmodule
