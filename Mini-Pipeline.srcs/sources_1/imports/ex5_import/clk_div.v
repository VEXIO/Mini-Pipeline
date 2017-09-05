`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:19:38 07/17/2012 
// Design Name: 
// Module Name:    clk_div 
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
module clk_div(input clk,
					input rst,
					input SW2,
					output reg[31:0]clkdiv,
                    output wire [31:0] cnt_display,
					output Clk_CPU
					);
					
// Clock divider-Ê±ÖÓ·ÖÆµÆ÷


	always @ (posedge clk or posedge rst) begin 
		if (rst) clkdiv <= 0; else clkdiv <= clkdiv + 1'b1; end
		
	assign Clk_CPU=(SW2)? clkdiv[20] : clkdiv[25];
    assign cnt_display=(SW2) ? {20'b0,clkdiv[31:20]} : {15'b0,clkdiv[31:15]};
		
endmodule
