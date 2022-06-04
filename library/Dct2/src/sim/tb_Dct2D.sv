module tb_Dct2D ();

    parameter ImgWidth  = 1024;
    parameter DinWidth  = 8;
    parameter DoutWidth = 16;
    parameter Type      = "dct"; // "idct"

    logic                           clk_i;
    logic                           rst_i;

    logic                           s_valid_i;
    logic                           s_ready_o;
    logic                           s_eol_i;
    logic                           s_sof_i;
    logic   [0:7][DinWidth-1:0]     s_data_i;

    logic                           m_valid_o;
    logic                           m_ready_i;
    logic                           m_eol_o;
    logic                           m_sof_o;
    logic   [0:7][DoutWidth-1:0]    m_data_o;

    real in[0:7][0:ImgWidth-1];
    real out[0:7];

    int   width, height;

    initial begin
        integer fd;
        fd = $fopen("tb_Dct2D_input.txt", "r");
        $fscanf(fd, "%d", height);
        $fscanf(fd, "%d", width);
        for (int line = 0; line < height; line++) begin
            for (int col = 0; col < width; col++) begin
                $fscanf(fd, "%f", in[line][col]);
            end
        end
        $fclose(fd);
    end

    function logic [0:7][DinWidth-1:0] ToInputConv;
        input real din[0:7];
    begin
        logic [0:7][DinWidth-1:0] result;
        for (int i = 0; i < 8; i++) begin
            result[i] = $rtoi(din[i] * 256);
        end
        return result;
    end
    endfunction

    always_comb begin
        for (int i = 0; i < 8; i++) begin
            logic signed [DoutWidth-1:0] data;
            data = m_data_o[i];
            out[i] = data / 256.0;
        end
    end

    always #5 clk_i = ~clk_i;
    initial begin
        rst_i = 1;
        clk_i = 1;
        m_ready_i = 1;
        s_valid_i = 0;
        s_eol_i = 0;
        s_sof_i = 0;
        @(posedge clk_i);
        @(posedge clk_i);
        rst_i = 0;
        @(posedge clk_i);

        s_valid_i = 1;
        for (int line = 0; line < 8; line++) begin
            for (int col = 0; col < width; col += 8) begin
                s_sof_i = (line == 0) && (col == 0);
                s_eol_i = (col == width-8);

                for (int i = 0; i < 8; i++) begin
                    s_data_i[i] = $rtoi(in[line][col+i] * 256);
                end
                @(posedge clk_i);
            end
        end
        s_valid_i = 0;
    end

    always @(posedge clk_i)
        m_ready_i <= $urandom_range(0, 1);

    initial begin
        int end_image;
        integer fd;

        fd = $fopen("tb_Dct2D_output.csv", "w");
        end_image = 0;

        while (!end_image) begin
            @(posedge clk_i)
            if (m_valid_o & m_ready_i) begin

                for (int i = 0; i < 8; i++) begin
                    $fwrite(fd, "%.8f%s", 
                        out[i],
                        ((i == 7) & m_eol_o) ? "\n" : ", "
                    );
                end
            end
        end
        $fclose(fd);
    end

    Dct2D #(
        .ImgWidth(ImgWidth),
        .DinWidth(DinWidth),
        .DoutWidth(DoutWidth),
        .Type(Type)
    ) DUT (
        .*
    );
endmodule