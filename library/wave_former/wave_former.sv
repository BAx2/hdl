module wave_former (
    input   logic           s_axis_video_aclk,
    input   logic           s_axis_video_areset,

    input   logic   [23:0]  s_axis_video_tdata,     // data
    input   logic           s_axis_video_tvalid,    // valid
    output  logic           s_axis_video_tready,    // ready
    input   logic           s_axis_video_tlast,     // end of line
    input   logic   [00:0]  s_axis_video_tuser,     // start of frame

    output  logic   [23:0]  m_axis_video_tdata,
    output  logic           m_axis_video_tvalid,
    input   logic           m_axis_video_tready,
    output  logic           m_axis_video_tlast,
    output  logic   [00:0]  m_axis_video_tuser,

    input   logic           s_axi_aclk,
    input   logic           s_axi_aresetn,

    input   logic           s_axi_awvalid,
    input   logic [4:0]     s_axi_awaddr,
    output  logic           s_axi_awready,
    input   logic           s_axi_wvalid,
    input   logic [31:0]    s_axi_wdata,
    input   logic [ 3:0]    s_axi_wstrb,
    output  logic           s_axi_wready,
    output  logic           s_axi_bvalid,
    output  logic [ 1:0]    s_axi_bresp,
    input   logic           s_axi_bready,
    input   logic           s_axi_arvalid,
    input   logic [4:0]     s_axi_araddr,
    output  logic           s_axi_arready,
    output  logic           s_axi_rvalid,
    output  logic [ 1:0]    s_axi_rresp,
    output  logic [31:0]    s_axi_rdata,
    input   logic           s_axi_rready
);
    localparam RECALC_X_STAGES = 5;
    localparam HORIZONTAL_WAVE_STAGES = 10;
    localparam WAVE_DECAY_STAGES = 10;

    // parameters from axi4-lite
    logic [15:0] x_offset,
                 y_offset,
                 omega,
                 wave_aplitude,
                 decay_amplitude,
                 phase_inc;

    logic enable;
    logic [15:0] current_x, current_y, recalc_x;
    logic [15:0] wave_k, prev_decay_k, decay_k, common_k;
    logic [15:0] phase;

    axi_wave_former_regmap regmap (
        .up_rstn(s_axi_aresetn),
        .up_clk(s_axi_aclk),
        .out_clk(s_axis_video_aclk),
        .up_axi_awvalid(s_axi_awvalid),
        .up_axi_awaddr(s_axi_awaddr),
        .up_axi_awready(s_axi_awready),
        .up_axi_wvalid(s_axi_wvalid),
        .up_axi_wdata(s_axi_wdata),
        .up_axi_wstrb(s_axi_wstrb),
        .up_axi_wready(s_axi_wready),
        .up_axi_bvalid(s_axi_bvalid),
        .up_axi_bresp(s_axi_bresp),
        .up_axi_bready(s_axi_bready),
        .up_axi_arvalid(s_axi_arvalid),
        .up_axi_araddr(s_axi_araddr),
        .up_axi_arready(s_axi_arready),
        .up_axi_rvalid(s_axi_rvalid),
        .up_axi_rresp(s_axi_rresp),
        .up_axi_rdata(s_axi_rdata),
        .up_axi_rready(s_axi_rready),
        .x_offset(x_offset),
        .y_offset(y_offset),
        .omega(omega),
        .wave_aplitude(wave_aplitude),
        .decay_amplitude(decay_amplitude),
        .phase_inc(phase_inc)
    );

    coordinate_calc coordinate_calc_inst (
        .clk(s_axis_video_aclk),
        .rst(s_axis_video_areset),

        .valid(s_axis_video_tvalid),
        .ready(s_axis_video_tready),
        .sof(s_axis_video_tuser),
        .eol(s_axis_video_tlast),

        .x(current_x),
        .y(current_y)
    );

    coordinate_recalc #(
        .STAGES(RECALC_X_STAGES)
    ) coordinate_recalc_inst (
        .clk(s_axis_video_aclk),
        .rst(s_axis_video_areset),
        .en(enable),

        .x_offset(x_offset),
        .y_offset(y_offset), 

        .x(current_x),
        .y(current_y),

        .x0(recalc_x)
    );

    phase_generator phase_generator_inst (
        .clk(s_axis_video_aclk),
        .rst(s_axis_video_areset),
        .enable(s_axis_video_tvalid & s_axis_video_tuser),
        .phase_inc(phase_inc),
        .phase(phase)
    );

    horizontal_wave #(
        .STAGES(HORIZONTAL_WAVE_STAGES)
    ) horizontal_wave_inst (
        .clk(s_axis_video_aclk),
        .rst(s_axis_video_areset),
        .en(enable),

        .phase(phase),
        .x(recalc_x), 
        .omega(omega),
        .amplitude(wave_aplitude),

        .koef(wave_k)
    );

    wave_decay #(
        .STAGES(WAVE_DECAY_STAGES)
    ) wave_decay_inst (
        .clk(s_axis_video_aclk),
        .rst(s_axis_video_areset),
        .en(enable),

        .x_offset(x_offset),
        .y_offset(y_offset), 
        .amplitude(decay_amplitude),

        .x(current_x),
        .y(current_y),

        .koef(prev_decay_k)
    );

    delay_line #(
        .TYPE(type(prev_decay_k)),
        .DELAY(RECALC_X_STAGES + HORIZONTAL_WAVE_STAGES + 3 - WAVE_DECAY_STAGES)
    ) delay_decay_k (
        .clk(s_axis_video_aclk),
        .en(enable),
        .din(prev_decay_k),
        .dout(decay_k)
    );

    fix_mult_sign_1_15 mult_common_k (
        .clk(s_axis_video_aclk),
        .en(enable),
        .rst(s_axis_video_areset),
        .a(decay_k),
        .b(wave_k),
        .res(common_k)
    );

    typedef struct packed
    {
        logic [7:0] r;
        logic [7:0] b;
        logic [7:0] g;
        logic       valid;
        logic       sof;
        logic       eol;
    } axis_vdata_t;

    axis_vdata_t input_data, delay_data, out_reg;
    assign input_data.r = s_axis_video_tdata[23:16],
           input_data.b = s_axis_video_tdata[15:08],
           input_data.g = s_axis_video_tdata[07:00],
           input_data.valid = s_axis_video_tvalid,
           input_data.sof = s_axis_video_tuser,
           input_data.eol = s_axis_video_tlast;

    delay_line  #(
        .TYPE(axis_vdata_t),
        .DELAY(RECALC_X_STAGES + HORIZONTAL_WAVE_STAGES + 7)
    ) delay_valid_data (
        .clk(s_axis_video_aclk),
        .en(enable),
        .din(input_data),
        .dout(delay_data)
    );

    // output = data * (decay_k * wave_k) = 
    //        = data * common_k;

    always_ff @(posedge s_axis_video_aclk)
    begin
        if (s_axis_video_areset)
        begin
            out_reg.r     <= 0;
            out_reg.b     <= 0;
            out_reg.g     <= 0;
            out_reg.valid <= 0;
            out_reg.sof   <= 0;
            out_reg.eol   <= 0;
        end
        else if (enable)
        begin
            logic [23:0] out_rdata_ext, out_gdata_ext, out_bdata_ext;
            out_rdata_ext = delay_data.r * common_k;
            out_gdata_ext = delay_data.g * common_k;
            out_bdata_ext = delay_data.b * common_k;
            
            out_reg.r <= out_rdata_ext >> 15;
            out_reg.b <= out_bdata_ext >> 15;
            out_reg.g <= out_gdata_ext >> 15;
            out_reg.valid <= delay_data.valid;
            out_reg.sof <= delay_data.sof;
            out_reg.eol <= delay_data.eol;
            // out_reg <= delay_data;  
        end
    end

    ctrl_unit ctrl_inst (
        .clk(s_axis_video_aclk),
        .reset(s_axis_video_areset),

        .s_valid(s_axis_video_tvalid),
        .delay_valid(delay_data.valid),
        .m_ready(m_axis_video_tready),

        .enable(enable),
        .s_ready(s_axis_video_tready),
        .m_valid()
    );

    assign
        m_axis_video_tdata  = {out_reg.r, out_reg.b, out_reg.g},
        m_axis_video_tvalid = out_reg.valid,
        m_axis_video_tlast  = out_reg.eol,
        m_axis_video_tuser  = out_reg.sof;

endmodule