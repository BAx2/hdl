module tb_Dct1D ();
    parameter DinWidth = 8;
    parameter DoutWidth = 16;
    parameter InputReg = 1;
    parameter OutputReg = 1;

    logic                           clk_i;
    logic                           rst_i;

    logic                           s_valid_i;
    logic                           s_ready_o;
    logic   [0:7][DinWidth-1:0]     s_data_i;

    logic                             m_valid_o;
    logic                             m_ready_i;
    logic signed [0:7][DoutWidth-1:0] m_data_o;

    real out[0:7];
    real in[0:7];

    always_comb begin
        for (int i = 0; i < 8; i++) begin
            logic signed [DoutWidth-1:0] data;
            data = m_data_o[i];
            out[i] = data / $pow(2.0, 8); 
            s_data_i[i] = $rtoi(in[i] * $pow(2, 8));
        end
    end

    always #5 clk_i = ~clk_i;
    initial begin
        rst_i = 1;
        clk_i = 1;
        m_ready_i = 1;
        s_valid_i = 0;
        @(posedge clk_i);
        @(posedge clk_i);
        @(posedge clk_i);
        rst_i = 0;

        s_valid_i = 1;
        for (int i = 0; i < 8; i++) begin
            in[i] = i / 8.0;
        end

        @(posedge clk_i);
        in = {1, 7, 0, 2, 3, 6, 4, 5};
        for (int i = 0; i < 8; i++) in[i] = in[i] / 8.0;

    end

    Dct1D #(
        .DinWidth(DinWidth),
        .DoutWidth(DoutWidth),
        .InputReg(InputReg),
        .OutputReg(OutputReg)
    ) DUT ( 
        .* 
    );
endmodule