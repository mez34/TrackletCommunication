// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.3 (lin64) Build 1034051 Fri Oct  3 16:32:59 MDT 2014
// Date        : Thu Apr 16 13:29:28 2015
// Host        : localhost running 64-bit Scientific Linux release 6.5 (Carbon)
// Command     : write_verilog -force -mode synth_stub
//               /home/user/project_1/project_1.srcs/sources_1/ip/fifo_projection_out/fifo_projection_out_stub.v
// Design      : fifo_projection_out
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k70tfbg676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v12_0,Vivado 2014.3" *)
module fifo_projection_out(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, empty)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[47:0],wr_en,rd_en,dout[47:0],full,empty" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [47:0]din;
  input wr_en;
  input rd_en;
  output [47:0]dout;
  output full;
  output empty;
endmodule
