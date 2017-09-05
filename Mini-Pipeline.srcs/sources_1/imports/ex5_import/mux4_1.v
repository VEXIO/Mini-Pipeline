`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:34:43 06/01/2017 
// Design Name: 
// Module Name:    mux4_1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mux4_1(I0, I1, I2, I3, Ctrl, S);
    parameter N = 32;
    input  wire [1:0] Ctrl;
    input  wire [N-1:0] I0, I1, I2, I3;
    output wire [N-1:0] S;
    assign S = Ctrl==2'b00 ? I0 : 
               Ctrl==2'b01 ? I1 :
               Ctrl==2'b10 ? I2 : I3;
endmodule

