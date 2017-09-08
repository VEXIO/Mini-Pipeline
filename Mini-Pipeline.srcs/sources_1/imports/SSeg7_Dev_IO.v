`timescale 1ns / 1ps
module SSeg7_Dev(
    input clk, // clk
    input rst, // reset
    input Start, // sync start
    input SW0, // text / seg
    input flash, // flash freq
    input[31:0]Hexs, // input data
    input[7:0]point, // input point
    input[7:0]LES, // blink EN
    output seg_clk, // sync clk
    output seg_sout, // sync sout
    output SEG_PEN, // sync PEN
    output seg_clrn // sync reset
);
endmodule
