/**
 * Scan inputs from button matrix.
 * Author: Zhao, Hongyu  <power_zhy@foxmail.com>
 * Editor: Frank Shaw	 <xiaoqingzhe@gmail.com>
 */
module btn_scan_sword (
	input wire clk,  // main clock
	input wire rst,  // synchronous reset
	output reg [4:0] btn_x,	//matrix button for output
	input wire [4:0] btn_y,	//matrix button for input
	output reg [24:0] btn_result	//result represent for button
	);
	
endmodule
