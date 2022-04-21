
`timescale 1 ns / 1 ps

	module PWM #
	(
		// Users to add parameters here
        parameter integer NUM_PWM    = 1,
        parameter reg POLARITY = 1'b1,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface PWM_AXI
		parameter integer C_PWM_AXI_DATA_WIDTH	= 32,
		parameter integer C_PWM_AXI_ADDR_WIDTH	= 7
	)
	(
		// Users to add ports here
        output wire [NUM_PWM-1 : 0] pwm,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface PWM_AXI
		input wire  s_axi_aclk,
		input wire  s_axi_aresetn,
		input wire [C_PWM_AXI_ADDR_WIDTH-1 : 0] s_axi_awaddr,
		input wire [2 : 0] s_axi_awprot,
		input wire  s_axi_awvalid,
		output wire  s_axi_awready,
		input wire [C_PWM_AXI_DATA_WIDTH-1 : 0] s_axi_wdata,
		input wire [(C_PWM_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb,
		input wire  s_axi_wvalid,
		output wire  s_axi_wready,
		output wire [1 : 0] s_axi_bresp,
		output wire  s_axi_bvalid,
		input wire  s_axi_bready,
		input wire [C_PWM_AXI_ADDR_WIDTH-1 : 0] s_axi_araddr,
		input wire [2 : 0] s_axi_arprot,
		input wire  s_axi_arvalid,
		output wire  s_axi_arready,
		output wire [C_PWM_AXI_DATA_WIDTH-1 : 0] s_axi_rdata,
		output wire [1 : 0] s_axi_rresp,
		output wire  s_axi_rvalid,
		input wire  s_axi_rready
	);
	
    wire [C_PWM_AXI_DATA_WIDTH-1:0]ctrl_reg;
    wire [C_PWM_AXI_DATA_WIDTH-1:0]status_reg;
	wire [C_PWM_AXI_DATA_WIDTH-1:0]duty_reg [0:NUM_PWM-1];
	wire [C_PWM_AXI_DATA_WIDTH-1:0]period_reg;
	
// Instantiation of Axi Bus Interface PWM_AXI
	PWM_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_PWM_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_PWM_AXI_ADDR_WIDTH),
		.NUM_PWM(NUM_PWM)
	) PWM_AXI_inst (
	    .ctrl_reg_out(ctrl_reg),
	    .status_reg_out(status_reg),
        .duty_reg_out(duty_reg),
        .period_reg_out(period_reg),
		.S_AXI_ACLK(s_axi_aclk),
		.S_AXI_ARESETN(s_axi_aresetn),
		.S_AXI_AWADDR(s_axi_awaddr),
		.S_AXI_AWPROT(s_axi_awprot),
		.S_AXI_AWVALID(s_axi_awvalid),
		.S_AXI_AWREADY(s_axi_awready),
		.S_AXI_WDATA(s_axi_wdata),
		.S_AXI_WSTRB(s_axi_wstrb),
		.S_AXI_WVALID(s_axi_wvalid),
		.S_AXI_WREADY(s_axi_wready),
		.S_AXI_BRESP(s_axi_bresp),
		.S_AXI_BVALID(s_axi_bvalid),
		.S_AXI_BREADY(s_axi_bready),
		.S_AXI_ARADDR(s_axi_araddr),
		.S_AXI_ARPROT(s_axi_arprot),
		.S_AXI_ARVALID(s_axi_arvalid),
		.S_AXI_ARREADY(s_axi_arready),
		.S_AXI_RDATA(s_axi_rdata),
		.S_AXI_RRESP(s_axi_rresp),
		.S_AXI_RVALID(s_axi_rvalid),
		.S_AXI_RREADY(s_axi_rready)
	);
    
    reg [C_PWM_AXI_DATA_WIDTH-1:0]duty_reg_latch [0:NUM_PWM-1];
    reg [C_PWM_AXI_DATA_WIDTH-1:0] count=0;
    reg [C_PWM_AXI_DATA_WIDTH-1:0] max=4096;
    reg enable=1'b0;
    
	// Add user logic here
    always@(posedge (s_axi_aclk))begin
        if (ctrl_reg[0]==1) //Ctrl_reg 0 = enable
            enable<=1;
        else
            enable<=0;         
    end
    
    always@(posedge(s_axi_aclk))begin
        if (enable==1'b1)begin
            if (count<max)
                count=count+1;
            else begin
                count=0;
                max<=period_reg;
            end
        end
        else begin
            count=0;
            max<=period_reg;
        end
    end
    
    genvar i;
    generate
    for (i = 0; i < NUM_PWM ; i = i + 1) begin 
        always@(posedge(s_axi_aclk)) begin
            if (enable==1'b1) begin
                if (count>=max)
                    duty_reg_latch[i]=duty_reg[i];
            end
            else begin
               duty_reg_latch[i]=duty_reg[i];
            end
        end
        
        assign pwm[i] = ((duty_reg_latch[i] > count) && (enable==1'b1)) ? POLARITY : !POLARITY;
    end
    endgenerate
    
	// User logic ends

	endmodule
