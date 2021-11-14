module axi_wave_former_regmap #(
    localparam AXI_ADDRESS_WIDTH = 5 
)(
    input                             up_rstn,
    input                             up_clk,
    input                             out_clk,
    // axi4 interface

    input                             up_axi_awvalid,
    input   [(AXI_ADDRESS_WIDTH-1):0] up_axi_awaddr,
    output                            up_axi_awready,
    input                             up_axi_wvalid,
    input   [31:0]                    up_axi_wdata,
    input   [ 3:0]                    up_axi_wstrb,
    output                            up_axi_wready,
    output                            up_axi_bvalid,
    output  [ 1:0]                    up_axi_bresp,
    input                             up_axi_bready,
    input                             up_axi_arvalid,
    input   [(AXI_ADDRESS_WIDTH-1):0] up_axi_araddr,
    output                            up_axi_arready,
    output                            up_axi_rvalid,
    output  [ 1:0]                    up_axi_rresp,
    output  [31:0]                    up_axi_rdata,
    input                             up_axi_rready,

    // output cfg
    output logic [15:0]               x_offset,
    output logic [15:0]               y_offset,
    output logic [15:0]               omega,
    output logic [15:0]               wave_aplitude,
    output logic [15:0]               decay_amplitude,
    output logic [15:0]               phase_inc
);


    logic                             up_wreq;
    logic [(AXI_ADDRESS_WIDTH-3):0]   up_waddr;
    logic [31:0]                      up_wdata;
    logic                             up_wack;
    logic                             up_rreq;
    logic [(AXI_ADDRESS_WIDTH-3):0]   up_raddr;
    logic [31:0]                      up_rdata;
    logic                             up_rack;


    up_axi #(AXI_ADDRESS_WIDTH) up_axi_inst 
    (
        .up_rstn(up_rstn),
        .up_clk(up_clk),
        .up_axi_awvalid(up_axi_awvalid),
        .up_axi_awaddr(up_axi_awaddr),
        .up_axi_awready(up_axi_awready),
        .up_axi_wvalid(up_axi_wvalid),
        .up_axi_wdata(up_axi_wdata),
        .up_axi_wstrb(up_axi_wstrb),
        .up_axi_wready(up_axi_wready),
        .up_axi_bvalid(up_axi_bvalid),
        .up_axi_bresp(up_axi_bresp),
        .up_axi_bready(up_axi_bready),
        .up_axi_arvalid(up_axi_arvalid),
        .up_axi_araddr(up_axi_araddr),
        .up_axi_arready(up_axi_arready),
        .up_axi_rvalid(up_axi_rvalid),
        .up_axi_rresp(up_axi_rresp),
        .up_axi_rdata(up_axi_rdata),
        .up_axi_rready(up_axi_rready),
        .up_wreq(up_wreq),
        .up_waddr(up_waddr),
        .up_wdata(up_wdata),
        .up_wack(up_wack),
        .up_rreq(up_rreq),
        .up_raddr(up_raddr),
        .up_rdata(up_rdata),
        .up_rack(up_rack)
    );

    localparam REGS_NUM = 2**(AXI_ADDRESS_WIDTH-2);
    logic [31:0] regs [0:REGS_NUM-1];

    always_ff @(posedge up_clk)
    begin
        if (!up_rstn)
        begin
            up_wack <= 0;
            for (int i = 0; i < REGS_NUM-1; i++)
            begin
                regs[i] <= 0;
            end
        end
        else
        begin
            up_wack <= up_wreq;
            if (up_wreq)
            begin
                regs[up_waddr] <= up_wdata;
            end
        end
    end

    always_ff @(posedge up_clk)
    begin
        if (!up_rstn)
        begin
            up_rack <= 0;
            up_rdata <= 0;
        end
        else
        begin
            up_rack <= up_rreq;
            if (up_rreq)
            begin
                up_rdata <= regs[up_raddr];
            end
            else
            begin
                up_rdata <= 0;
            end
        end
    end


    /////  regmap
    // assign
    //     x_offset        = regs[0],
    //     y_offset        = regs[1],
    //     omega           = regs[2],
    //     wave_aplitude   = regs[3],
    //     decay_amplitude = regs[4],
    //     phase_inc       = regs[5];

    localparam DEST_FF = 2;
    localparam SIM_MSG = 0;
    localparam SRC_REG = 0;
    localparam WIDTH = 32;
    localparam PLATFORM = "xilinx";

    cdc_array_single #(DEST_FF, SIM_MSG, SRC_REG, WIDTH, PLATFORM) cdc_x_offset        (up_clk, out_clk, regs[0], x_offset);
    cdc_array_single #(DEST_FF, SIM_MSG, SRC_REG, WIDTH, PLATFORM) cdc_y_offset        (up_clk, out_clk, regs[1], y_offset);
    cdc_array_single #(DEST_FF, SIM_MSG, SRC_REG, WIDTH, PLATFORM) cdc_omega           (up_clk, out_clk, regs[2], omega);
    cdc_array_single #(DEST_FF, SIM_MSG, SRC_REG, WIDTH, PLATFORM) cdc_wave_aplitude   (up_clk, out_clk, regs[3], wave_aplitude);
    cdc_array_single #(DEST_FF, SIM_MSG, SRC_REG, WIDTH, PLATFORM) cdc_decay_amplitude (up_clk, out_clk, regs[4], decay_amplitude);
    cdc_array_single #(DEST_FF, SIM_MSG, SRC_REG, WIDTH, PLATFORM) cdc_phase_inc       (up_clk, out_clk, regs[5], phase_inc);

endmodule