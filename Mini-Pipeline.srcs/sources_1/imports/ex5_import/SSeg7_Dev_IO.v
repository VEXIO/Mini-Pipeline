`timescale 1ns / 1ps
module  SSeg7_Dev(
    input clk,
    input rst,
    input Start,
    input SW0,
    input flash,
    input [31:0] Hexs,
    input [7:0] point,
    input [7:0] LES,
    output seg_clk,
    output seg_sout,
    output SEG_PEN,
    output seg_clrn
);
endmodule