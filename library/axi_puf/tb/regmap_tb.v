// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_puf_regmap_tb;
  parameter VCD_FILE = {`__FILE__,"cd"};

  `define TIMEOUT 10000
  `include "tb_base.v"

  localparam AW = 16;
  localparam NUM_REGS = 'h4;

  wire s_axi_aclk = clk;
  wire s_axi_aresetn = ~reset;

  reg s_axi_awvalid = 1'b0;
  reg s_axi_wvalid = 1'b0;
  reg [AW-1:0] s_axi_awaddr = 'h00;
  reg [31:0] s_axi_wdata = 'h00;
  wire [1:0] s_axi_bresp;
  wire s_axi_awready;
  wire s_axi_wready;
  wire s_axi_bready = 1'b1;
  wire [3:0] s_axi_wstrb = 4'b1111;
  wire [2:0] s_axi_awprot = 3'b000;
  wire [2:0] s_axi_arprot = 3'b000;
  wire [1:0] s_axi_rresp;
  wire [31:0] s_axi_rdata;

  task write_reg;
  input [31:0] addr;
  input [31:0] value;
  begin
    @(posedge s_axi_aclk)
    s_axi_awvalid <= 1'b1;
    s_axi_wvalid <= 1'b1;
    s_axi_awaddr <= addr;
    s_axi_wdata <= value;
    @(posedge s_axi_aclk)
    while (s_axi_awvalid || s_axi_wvalid) begin
      @(posedge s_axi_aclk)
      if (s_axi_awready)
        s_axi_awvalid <= 1'b0;
      if (s_axi_wready)
        s_axi_wvalid <= 1'b0;
    end
  end
  endtask

  reg [31:0] expected_reg_mem[0:NUM_REGS-1];

  reg [AW-1:0] s_axi_araddr = 'h0;
  reg s_axi_arvalid = 'h0;
  reg s_axi_rready = 'h0;
  wire s_axi_arready;
  wire s_axi_rvalid;

  task read_reg;
  input [31:0] addr;
  output [31:0] value;
  begin
    s_axi_arvalid <= 1'b1;
    s_axi_araddr <= addr;
    s_axi_rready <= 1'b1;
    @(posedge s_axi_aclk) #0;
    while (s_axi_arvalid) begin
      if (s_axi_arready == 1'b1) begin
        s_axi_arvalid <= 1'b0;
      end
      @(posedge s_axi_aclk) #0;
    end

    while (s_axi_rready) begin
      if (s_axi_rvalid == 1'b1) begin
        value <= s_axi_rdata;
        s_axi_rready <= 1'b0;
      end
      @(posedge s_axi_aclk) #0;
    end
  end
  endtask

  task read_reg_check;
  input [31:0] addr;
  output match;
  reg [31:0] value;
  reg [31:0] expected;
  input [255:0] message;
  begin
    read_reg(addr, value);
    expected = expected_reg_mem[addr[11:2]];
    match <= value === expected;
    if (value !== expected) begin
      $display("%0s: Register mismatch for %x. Expected %x, got %x",
        message, addr, expected, value);
    end
  end
  endtask

  reg read_match = 1'b1;

  always @(posedge clk) begin
    if (read_match == 1'b0) begin
      failed <= 1'b1;
    end
  end

  task set_reset_reg_value;
  input [31:0] addr;
  input [31:0] value;
  begin
    expected_reg_mem[addr[AW-1:2]] <= value;
  end
  endtask

  task initialize_expected_reg_mem;
  integer i;
  begin
    for (i = 0; i < NUM_REGS; i = i + 1)
      expected_reg_mem[i] <= 'h00;
    /* Non zero power-on-reset values */
    set_reset_reg_value('h00, 32'h00000001); /* PCORE version register */
	set_reset_reg_value('h04, 32'h00000000); /* PCORE ID register */
    set_reset_reg_value('h08, 32'h47465550); /* PCORE magic register */
    set_reset_reg_value('h0c, 32'h00000000); /* seed */
	set_reset_reg_value('h10, 32'h00000000); /* poly */
	set_reset_reg_value('h14, 32'h00000000); /* cnt */
  end
  endtask

  task check_all_registers;
  input [255:0] message;
  integer i;
  begin
    for (i = 0; i < NUM_REGS*4; i = i + 4) begin
      read_reg_check(i, read_match, message);
    end
  end
  endtask

  task write_reg_and_update;
  input [31:0] addr;
  input [31:0] value;
  integer i;
  begin
    write_reg(addr, value);
    expected_reg_mem[addr[AW-1:2]] <= value;
  end
  endtask

  task invert_register;
  input [31:0] addr;
  reg [31:0] value;
  begin
    read_reg(addr, value);
    write_reg(addr, ~value);
  end
  endtask

  task invert_all_registers;
  integer i;
  begin
    for (i = 0; i < NUM_REGS*4; i = i + 4) begin
      invert_register(i);
    end
  end
  endtask

  integer i;
  initial begin
    initialize_expected_reg_mem();
    @(posedge s_axi_aresetn)
    check_all_registers("Initial");

    /* Check scratch */
	write_reg_and_update('h0c, 32'h00000001); /* seed */
	
	// "10001100000000000000000000000001"
	write_reg_and_update('h10, 32'h8c000001); /* poly  Phi(x) = x^32 + x^28 + x^27 + x^1 + 1  */
	write_reg_and_update('h14, 32'h00000003); /* cnt */
	write_reg_and_update('h1c, 32'h00000001); /* ask to start */
	
    check_all_registers("Scratch");

    /* Check that reset works for all registers */
    do_trigger_reset();
    initialize_expected_reg_mem();
    check_all_registers("Reset 1");
    invert_all_registers();
    do_trigger_reset();
    check_all_registers("Reset 2");

  end

  axi_puf #(
    .ID(0)
  ) i_axi (
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awready(s_axi_awready),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wready(s_axi_wready),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bready(s_axi_bready),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arready(s_axi_arready),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rdata(s_axi_rdata)
  );

endmodule
