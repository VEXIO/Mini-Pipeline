// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
// Date        : Wed Sep 13 15:12:32 2017
// Host        : DESKTOP-DM3G5QT running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               Z:/Mini-Pipeline/Mini-Pipeline.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1_stub.v
// Design      : blk_mem_gen_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_3,Vivado 2016.2" *)
module blk_mem_gen_1(clka, rsta, wea, addra, dina, douta, clkb, rstb, web, addrb, dinb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,rsta,wea[0:0],addra[12:0],dina[6:0],douta[6:0],clkb,rstb,web[0:0],addrb[12:0],dinb[6:0],doutb[6:0]" */;
  input clka;
  input rsta;
  input [0:0]wea;
  input [12:0]addra;
  input [6:0]dina;
  output [6:0]douta;
  input clkb;
  input rstb;
  input [0:0]web;
  input [12:0]addrb;
  input [6:0]dinb;
  output [6:0]doutb;
endmodule
