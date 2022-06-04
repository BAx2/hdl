module tb_ParralelToSerial ();

    parameter Width = 16;
    parameter N = 8;

    logic                      clk_i;
    logic                      rst_i;
    logic                      s_valid_i;
    logic                      s_ready_o;
    logic   [0:N-1][Width-1:0] s_data_i;
    logic                      m_valid_o;
    logic                      m_ready_i;
    logic          [Width-1:0] m_data_o;

    always #5 clk_i = ~clk_i;
    // always @(posedge clk_i) m_ready_i <= ~m_ready_i;
    int offset;

    initial begin
        rst_i = 1;
        clk_i = 1;
        m_ready_i = 1;
        s_valid_i = 0;
        offset = 0;
        for (int i = 0; i < N; i++) s_data_i[i] = i + offset;
        @(posedge clk_i);
        @(posedge clk_i);
        @(posedge clk_i);
        rst_i = 0;
        @(posedge clk_i);
        @(posedge clk_i);
        s_valid_i = 1;
    end

    always @(posedge clk_i) begin
        if (s_valid_i & s_ready_o) begin
            offset = offset + 1;
            for (int i = 0; i < N; i++) s_data_i[i] = i + offset;
        end
    end

    ParralelToSerial #(
        .Width(Width),
        .N(N)
    ) DUT (
        .*
    );

endmodule
