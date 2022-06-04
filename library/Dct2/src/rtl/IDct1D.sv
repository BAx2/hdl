module IDct1D #(
    parameter DinWidth  = 16,
    parameter DoutWidth = 8,
    parameter InputReg  = 1,
    parameter OutputReg = 1,
    parameter IntWidth  = 16,
    parameter IntPoint  = 10,
    parameter OutConstrain = 1,
    parameter OutMin = 0,
    parameter OutMax = 255
) (
    input   logic                           clk_i,
    input   logic                           rst_i,
    
    input   logic                           s_valid_i,
    output  logic                           s_ready_o,
    input   logic   [0:7][DinWidth-1:0]     s_data_i,

    output  logic                           m_valid_o,
    input   logic                           m_ready_i,
    output  logic   [0:7][DoutWidth-1:0]    m_data_o
);
    localparam Pi = 3.141592653589793;
    localparam logic signed [IntWidth-1:0] Sqrt2 = $rtoi(1.0 / $pow(2.0, 0.5) * (1 << IntPoint));

    function logic signed [IntWidth-1:0] Mult;
        input logic signed [IntWidth-1:0] a;
        input logic signed [IntWidth-1:0] b;
    begin
        logic signed [2*IntWidth-1:0] mul;
        mul = a * b;
        Mult = (mul >>> IntPoint);
    end
    endfunction

    function logic signed [IntWidth-1:0] Srl;
        input logic signed [IntWidth-1:0] a;
    begin
        Srl = {a[IntWidth-1], a[IntWidth-1:1]};
    end
    endfunction

    function logic signed [IntWidth-1:0] Constrain;
        input logic signed [IntWidth-1:0] a;
    begin
        if (!OutConstrain) begin
            Constrain = a;
        end else begin
            a = a > OutMax ? OutMax : a;
            a = a < OutMin ? OutMin : a;
            Constrain = a;
        end
    end
    endfunction


    logic signed [0:7][DinWidth-1:0] x;
    logic signed [0:7][IntWidth-1:0] y1_comb, y1;
    logic signed [0:7][IntWidth-1:0] y2_comb, y2;
    logic signed [0:7][IntWidth-1:0] y3_comb, y3;
    logic signed [0:7][IntWidth-1:0] y4_comb, y4;

    logic signed [IntWidth-1:0] r1_1, r1_2;
    logic signed [IntWidth-1:0] r3_1, r3_2;
    logic signed [IntWidth-1:0] r6_1, r6_2;

    always_comb begin
        y1_comb[0] = x[0];
        y1_comb[1] = x[1];
        y1_comb[2] = Mult(Sqrt2, x[2]);
        y1_comb[3] = Mult(Sqrt2, x[3]);
        y1_comb[4] = Srl(x[7] - x[4]);
        y1_comb[5] = Mult(Sqrt2, x[5]);
        y1_comb[6] = Mult(Sqrt2, x[6]);
        y1_comb[7] = Srl(x[7] + x[4]);
        
        y2_comb[0] = Srl(y1[0] + y1[1]);
        y2_comb[1] = Srl(y1[0] - y1[1]);
        y2_comb[2] = r6_1;
        y2_comb[3] = r6_2;
        y2_comb[4] = Srl(y1[4] + y1[6]);
        y2_comb[5] = Srl(y1[7] - y1[5]);
        y2_comb[6] = Srl(y1[4] - y1[6]);
        y2_comb[7] = Srl(y1[7] + y1[5]);

        y3_comb[0] = Srl(y2[0] + y2[3]);
        y3_comb[1] = Srl(y2[1] + y2[2]);
        y3_comb[2] = Srl(y2[1] - y2[2]);
        y3_comb[3] = Srl(y2[0] - y2[3]);
        y3_comb[4] = r3_1;
        y3_comb[5] = r1_1;
        y3_comb[6] = r1_2;
        y3_comb[7] = r3_2;

        y4_comb[0] = Constrain(Srl(y3[0] + y3[7]));
        y4_comb[1] = Constrain(Srl(y3[1] + y3[6]));
        y4_comb[2] = Constrain(Srl(y3[2] + y3[5]));
        y4_comb[3] = Constrain(Srl(y3[3] + y3[4]));
        y4_comb[4] = Constrain(Srl(y3[3] - y3[4]));
        y4_comb[5] = Constrain(Srl(y3[2] - y3[5]));
        y4_comb[6] = Constrain(Srl(y3[1] - y3[6]));
        y4_comb[7] = Constrain(Srl(y3[0] - y3[7]));

        m_data_o[0] = y4[0];
        m_data_o[1] = y4[1];
        m_data_o[2] = y4[2];
        m_data_o[3] = y4[3];
        m_data_o[4] = y4[4];
        m_data_o[5] = y4[5];
        m_data_o[6] = y4[6];
        m_data_o[7] = y4[7];
    end 

    logic x_valid, x_ready;
    logic y1_valid, y1_ready;
    logic y2_valid, y2_ready;
    logic y3_valid, y3_ready;
    logic y4_valid, y4_ready;

    Rotate #(
        .Width(IntWidth),
        .Point(IntPoint),
        .Angle(-1.0 * Pi / 16)
    ) Rotate_1_16 (
        .x1_i(y2[5]),
        .x2_i(y2[6]),
        .y1_o(r1_1),
        .y2_o(r1_2)
    );

    Rotate #(
        .Width(IntWidth),
        .Point(IntPoint),
        .Angle(-3.0 * Pi / 16)
    ) Rotate_3_16 (
        .x1_i(y2[4]),
        .x2_i(y2[7]),
        .y1_o(r3_1),
        .y2_o(r3_2)
    );

    Rotate #(
        .Width(IntWidth),
        .Point(IntPoint),
        .Angle(-6.0 * Pi / 16)
    ) Rotate_6_16 (
        .x1_i(y1[2]),
        .x2_i(y1[3]),
        .y1_o(r6_1),
        .y2_o(r6_2)
    );

    AxisReg #(
        .DataWidth($bits(x)),
        .Transperent(!InputReg),
        .Pipelined(1)
    ) InputRegInst (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_data_i({
            s_data_i[0],
            s_data_i[4],
            s_data_i[2],
            s_data_i[6],
            s_data_i[7],
            s_data_i[3],
            s_data_i[5],
            s_data_i[1]
        }),
        .s_valid_i(s_valid_i),
        .s_ready_o(s_ready_o),

        .m_ready_i(x_ready),
        .m_valid_o(x_valid),
        .m_data_o(x)
    );

    AxisReg #(
        .DataWidth($bits(y1)),
        .Transperent(0),
        .Pipelined(0)
    ) Y1RegInst (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_data_i(y1_comb),
        .s_valid_i(x_valid),
        .s_ready_o(x_ready),

        .m_data_o(y1),
        .m_valid_o(y1_valid),
        .m_ready_i(y1_ready)
    );

    AxisReg #(
        .DataWidth($bits(y2)),
        .Transperent(0),
        .Pipelined(0)
    ) Y2RegInst (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_data_i(y2_comb),
        .s_valid_i(y1_valid),
        .s_ready_o(y1_ready),

        .m_data_o(y2),
        .m_valid_o(y2_valid),
        .m_ready_i(y2_ready)
    );
    
    AxisReg #(
        .DataWidth($bits(y3)),
        .Transperent(0),
        .Pipelined(0)
    ) Y3RegInst (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_data_i(y3_comb),
        .s_valid_i(y2_valid),
        .s_ready_o(y2_ready),

        .m_data_o(y3),
        .m_valid_o(y3_valid),
        .m_ready_i(y3_ready)
    );

    AxisReg #(
        .DataWidth($bits(y4)),
        .Transperent(!OutputReg),
        .Pipelined(0)
    ) OutputRegInst (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .s_data_i(y4_comb),
        .s_valid_i(y3_valid),
        .s_ready_o(y3_ready),

        .m_data_o(y4),
        .m_valid_o(m_valid_o),
        .m_ready_i(m_ready_i)
    );
    
endmodule
