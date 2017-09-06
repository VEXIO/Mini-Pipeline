`timescale 1ns / 1ps
module mux4_1(
    input wire [1:0] Ctrl,
    input wire [31:0] I0,
    input wire [31:0] I1,
    input wire [31:0] I2,
    input wire [31:0] I3,
    output wire [31:0] S
);
    assign S = Ctrl == 2'b00 ? I0 :
               Ctrl == 2'b01 ? I1 :
               Ctrl == 2'b10 ? I2 : I3;
endmodule