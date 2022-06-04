module Dct1D #(
    parameter DinWidth = 8,
    parameter DoutWidth = 16,
    parameter InputReg = 1,
    parameter OutputReg = 1,
    parameter IntWidth = 16,
    parameter IntPoint = 10,
    parameter InputSigned = 0
) (
    input   logic                           clk_i,
    input   logic                           rst_i,
    
    output  logic                           s_ready_o,
    input   logic                           s_valid_i,
    input   logic                           s_sof_i,
    input   logic                           s_eol_i,
    input   logic   [0:7][DinWidth-1:0]     s_data_i,

    input   logic                           m_ready_i,
    output  logic                           m_valid_o,
    output  logic                           m_sof_o,
    output  logic                           m_eol_o,
    output  logic   [0:7][DoutWidth-1:0]    m_data_o
);
    localparam Pi = 3.141592653589793;
    localparam logic signed [IntWidth-1:0] Sqrt2 = $rtoi($pow(2.0, 0.5) * (1 << IntPoint));

    function logic signed [IntWidth-1:0] Mult;
        input logic signed [IntWidth-1:0] a;
        input logic signed [IntWidth-1:0] b;
    begin
        logic signed [2*IntWidth-1:0] mul;
        mul = a * b;
        Mult = (mul >>> IntPoint);
    end
    endfunction

    function logic signed [IntWidth-1:0] SignExpand;
        input logic signed [DinWidth-1:0] a;
    begin
        return a;
    end
    endfunction

    logic        [0:7][DinWidth-1:0] din;
    logic signed [0:7][IntWidth-1:0] x;

    logic signed [0:7][IntWidth-1:0] y1_comb, y1;
    logic signed [0:7][IntWidth-1:0] y2_comb, y2;
    logic signed [0:7][IntWidth-1:0] y3_comb, y3;
    logic signed [0:7][IntWidth-1:0] y4_comb, y4;

    generate
        genvar i;
        if (InputSigned) begin
            for (i = 0; i < 8; i++) begin
                assign x[i] = SignExpand(din[i]);
            end
        end
        else begin
            for (i = 0; i < 8; i++)
                assign x[i] = din[i];
        end
    endgenerate

    always_comb begin
        y1_comb[0] = x[0] + x[7];
        y1_comb[1] = x[1] + x[6];
        y1_comb[2] = x[2] + x[5];
        y1_comb[3] = x[3] + x[4];
        y1_comb[4] = -x[4] + x[3];
        y1_comb[5] = -x[5] + x[2];
        y1_comb[6] = -x[6] + x[1];
        y1_comb[7] = -x[7] + x[0];
        
        y2_comb[0] = y1[0] + y1[3];
        y2_comb[1] = y1[1] + y1[2];
        y2_comb[2] = y1[1] - y1[2];
        y2_comb[3] = y1[0] - y1[3];
        // y2_comb[4] = r3_1;
        // y2_comb[5] = r1_1;
        // y2_comb[6] = r1_2;
        // y2_comb[7] = r3_2;

        y3_comb[0] = y2[0] + y2[1];
        y3_comb[1] = y2[0] - y2[1];
        // y3_comb[2] = r6_1;
        // y3_comb[3] = r6_2;
        y3_comb[4] = y2[4] + y2[6];
        y3_comb[5] = -y2[5] + y2[7];
        y3_comb[6] = y2[4] - y2[6];
        y3_comb[7] = y2[5] + y2[7];

        y4_comb[0] = y3[0];
        y4_comb[1] = y3[1];
        y4_comb[2] = Mult(Sqrt2, y3[2]);
        y4_comb[3] = Mult(Sqrt2, y3[3]);
        y4_comb[4] = y3[7] - y3[4];
        y4_comb[5] = Mult(Sqrt2, y3[5]);
        y4_comb[6] = Mult(Sqrt2, y3[6]);
        y4_comb[7] = y3[7] + y3[4];

        m_data_o[0] = y4[0];
        m_data_o[1] = y4[7];
        m_data_o[2] = y4[2];
        m_data_o[3] = y4[5];
        m_data_o[4] = y4[1];
        m_data_o[5] = y4[6];
        m_data_o[6] = y4[3];
        m_data_o[7] = y4[4];
    end 

    logic x_valid, x_ready;
    logic y1_valid, y1_ready;
    logic y2_valid, y2_ready;
    logic y3_valid, y3_ready;
    logic [1:0] sof_eof_input_reg, sof_eof_y1, sof_eof_y2, sof_eof_y3, sof_eof_out_reg;


    AxisReg #(
        .DataWidth($bits(s_data_i)),
        .Transperent(!InputReg),
        .SideDataWidth(2),
        .Pipelined(1)
    ) InputRegInst (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_data_i(s_data_i),
        .s_valid_i(s_valid_i),
        .s_ready_o(s_ready_o),
        .s_side_data_i({ s_sof_i, s_eol_i }),

        .m_ready_i(x_ready),
        .m_valid_o(x_valid),
        .m_data_o(din),
        .m_side_data_o(sof_eof_input_reg)
    );

    AxisReg #(
        .DataWidth($bits(y1)),
        .Transperent(0),
        .SideDataWidth(2),
        .Pipelined(0)
    ) Y1RegInst (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_side_data_i(sof_eof_input_reg),
        .m_side_data_o(sof_eof_y1),

        .s_data_i(y1_comb),
        .s_valid_i(x_valid),
        .s_ready_o(x_ready),

        .m_data_o(y1),
        .m_valid_o(y1_valid),
        .m_ready_i(y1_ready)
    );

    Rotate #(
        .Width(IntWidth),
        .Point(IntPoint),
        .SideDataWidth(4*IntWidth),
        .Angle(1.0 * Pi / 16)
    ) Rotate_1_16 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .s_ready_o(y1_ready),
        .s_valid_i(y1_valid),
        .s_x1_i(y1[5]),
        .s_x2_i(y1[6]),
        .s_side_data_i({y2_comb[0:3]}),
        .m_ready_i(y2_ready),
        .m_valid_o(y2_valid),
        .m_y1_o(y2[5]),
        .m_y2_o(y2[6]),
        .m_side_data_o(y2[0:3])
    );

    Rotate #(
        .Width(IntWidth),
        .Point(IntPoint),
        .SideDataWidth(2),
        .Angle(3.0 * Pi / 16)
    ) Rotate_3_16 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .s_ready_o(),
        .s_valid_i(y1_valid),
        .s_x1_i(y1[4]),
        .s_x2_i(y1[7]),
        .s_side_data_i(sof_eof_y1),
        .m_ready_i(y2_ready),
        .m_valid_o(),
        .m_y1_o(y2[4]),
        .m_y2_o(y2[7]),
        .m_side_data_o(sof_eof_y2)
    );

    logic [6*IntWidth+2-1:0] side_data_r_6_16;
    Rotate #(
        .Width(IntWidth),
        .Point(IntPoint),
        .SideDataWidth(6*IntWidth+2),
        .Angle(6.0 * Pi / 16)
    ) Rotate_6_16 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .s_ready_o(y2_ready),
        .s_valid_i(y2_valid),
        .s_x1_i(y2[2]),
        .s_x2_i(y2[3]),
        .s_side_data_i({sof_eof_y2, y3_comb[0:1], y3_comb[4:7]}),
        .m_ready_i(y3_ready),
        .m_valid_o(y3_valid),
        .m_y1_o(y3[2]),
        .m_y2_o(y3[3]),
        .m_side_data_o(side_data_r_6_16)
    );

    assign y3[7]      = side_data_r_6_16[0*IntWidth +: IntWidth];
    assign y3[6]      = side_data_r_6_16[1*IntWidth +: IntWidth];
    assign y3[5]      = side_data_r_6_16[2*IntWidth +: IntWidth];
    assign y3[4]      = side_data_r_6_16[3*IntWidth +: IntWidth];
    assign y3[1]      = side_data_r_6_16[4*IntWidth +: IntWidth];
    assign y3[0]      = side_data_r_6_16[5*IntWidth +: IntWidth];
    assign sof_eof_y3 = side_data_r_6_16[6*IntWidth +: 2];

    AxisReg #(
        .DataWidth($bits(y4)),
        .Transperent(!OutputReg),
        .SideDataWidth(2),
        .Pipelined(0)
    ) OutputRegInst (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_side_data_i(sof_eof_y3),
        .m_side_data_o(sof_eof_out_reg),

        .s_data_i(y4_comb),
        .s_valid_i(y3_valid),
        .s_ready_o(y3_ready),

        .m_data_o(y4),
        .m_valid_o(m_valid_o),
        .m_ready_i(m_ready_i)
    );

    assign m_sof_o = sof_eof_out_reg[1];
    assign m_eol_o = sof_eof_out_reg[0];
    
endmodule
