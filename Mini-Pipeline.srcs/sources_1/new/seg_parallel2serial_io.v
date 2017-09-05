/**
 * Seg Parallel-Serial Converter.
 * Author: Frank Shaw    <xiaoqingzhe@gmail.com>
 */
module seg_parallel2serial (
	input wire clk,  // main clock should be 200MHz
	input wire rst,  // synchronous reset
	input wire [63:0] data,  // parallel input data
	input wire seg_en,	// seg enable signal
	output reg busy,  // busy flag
	output reg finish,  // finish acknowledgement
	output reg seg_clk = 0,  // serial clock
	output wire seg_pen,	// serial enable output
	output wire seg_dat  // serial output data
	);
	
endmodule
