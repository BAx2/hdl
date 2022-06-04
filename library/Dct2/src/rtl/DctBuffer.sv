module DctBuffer #(
    parameter DinWidth = 12,
    parameter ConvertionsPerLine = 1280 / 8
) (
    input   logic                               clk_i,
    input   logic                               rst_i,

    output  logic                               busy_o,

    input   logic   [7:0][DinWidth-1:0]         s_data_i,
    input   logic                               s_sof_i,
    input   logic                               s_eol_i,
    input   logic                               s_valid_i,
    output  logic                               s_ready_o,

    // output  logic   [7:0][7:0][DinWidth-1:0]    m_data_o,
    output  logic   [7:0][DinWidth-1:0]         m_data_o,
    output  logic                               m_sof_o,
    output  logic                               m_eol_o,
    output  logic                               m_valid_o,
    input   logic                               m_ready_i
);
    localparam BramAddrWidth = $clog2(ConvertionsPerLine);

    logic                                       new_sample;
    logic                                       next_line;
    logic   [2:0]                               current_line;
    logic   [$clog2(ConvertionsPerLine)-1:0]    samples_cnt;

    logic   [$clog2(ConvertionsPerLine)-1:0]    line_width;
    logic   [$clog2(ConvertionsPerLine)-1:0]    eol_period;
    
    logic   [BramAddrWidth-1:0]                 bram_waddr;
    logic                                       bram_we;
    
    logic                                       bram_re;
    logic   [BramAddrWidth-1:0]                 bram_raddr;
    logic   [0:7][0:7][DinWidth-1:0]            bram_rdata;

    logic                                       next_out;
    logic                                       sof;
    logic   [2:0]                               current_offset;
    
    typedef enum { Write, Read } State;
    State state, next_state;
    
    assign busy_o = (state == Read);

    //  FSM
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            state <= Write;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            Write: begin
                if ((current_line == 7) && next_line) begin
                    next_state = Read;
                end
                else begin
                    next_state = Write;
                end
            end
            Read: begin
                if (next_out & m_eol_o & (current_offset == 7)) begin
                    next_state = Write;
                end
                else begin
                    next_state = Read;
                end
            end
            default: 
                next_state = Write; 
        endcase
    end
    
    // Sof reg
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            sof <= 0;
        end
        else if (new_sample && (current_line == 0) && (samples_cnt == 0)) begin
            sof <= s_sof_i;
        end 
        else if (next_out & (state == Read)) begin
            sof <= 0;
        end
    end

    // Save Line Width
    // Save Eol period
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            line_width <= 0;
            eol_period <= 0;
        end
        else begin
            if (next_line) begin
                line_width <= samples_cnt;
                eol_period <= samples_cnt;
            end
        end
    end

    // Write logic
    assign s_ready_o = (state == Write);
    assign new_sample = s_valid_i & s_ready_o;
    assign next_line = new_sample & s_eol_i;

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            current_line <= 0;
        end 
        else begin
            if (next_line) begin
                current_line <= current_line + 1;
            end
        end
    end

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            samples_cnt <= 0;
        end
        else begin
            if (next_line) begin
                samples_cnt <= 0;
            end
            else if (new_sample) begin
                samples_cnt <= samples_cnt + 1;
            end
        end
    end

    // Read logic   
    assign m_valid_o = (state == Read);

    assign m_sof_o = sof;
    assign next_out = m_valid_o & m_ready_i;

    // assign m_eol_o = 0;

    logic [$clog2(ConvertionsPerLine)-1:0] line_data_cnt;
    always_ff @(posedge clk_i) begin
        if (state == Read) begin
            if (next_out) begin
                if (line_data_cnt == eol_period) begin
                    line_data_cnt <= 0;
                end
                else begin
                    line_data_cnt <= line_data_cnt + 1;
                end
            end
        end else begin
            line_data_cnt <= 0;
        end
    end
    assign m_eol_o = (line_data_cnt == eol_period);

    assign bram_re = next_out || (state == Write);

    // Raddr formin
    always_ff @(posedge clk_i) begin
        if (state == Read) begin
            if (next_out) begin
                if (bram_raddr == line_width) begin
                    bram_raddr <= 0;
                end
                else begin
                    bram_raddr <= bram_raddr + 'd1;
                end
            end                    
        end
        else begin
            bram_raddr <= (next_state == Read) ? 1 : 0;
        end
    end

    // current coeff select
    always_ff @(posedge clk_i) begin
        if (state == Read) begin
            if (next_out & m_eol_o) begin
                current_offset <= current_offset + 1;
            end                    
        end
        else begin
            current_offset <= 0;
        end
    end

    //
    assign bram_we = new_sample;
    assign bram_waddr = samples_cnt;
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            Bram #(
                .DataWidth(8 * DinWidth),
                .AddrWidth(BramAddrWidth)
            ) LineBufferInst (
                .clka_i(clk_i),
                .clkb_i(clk_i),
                .addra_i(bram_waddr),
                .ena_i(1'b1),
                .wea_i(bram_we && (current_line == i)),
                .dina_i(s_data_i),
                .douta_o(),
                .addrb_i(bram_raddr),
                .enb_i(bram_re),
                .web_i(1'b0),
                .dinb_i({DinWidth{8'b0}}),
                .doutb_o(bram_rdata[i])
            );
        end
    endgenerate
    
    always_comb begin
        for (int i = 0; i < 8; i++) begin
            m_data_o[7 - i] = bram_rdata[i][current_offset];
        end
    end

endmodule