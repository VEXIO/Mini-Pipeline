`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:22:31 04/13/2017 
// Design Name: 
// Module Name:    regs 
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
module regs(clk, rst, display, reg_R_addr_A, reg_R_addr_B, reg_W_addr, wdata, reg_we, rdata_A, rdata_B, display_out);
    input wire clk, rst, reg_we;
    input wire[4:0] reg_R_addr_A, reg_R_addr_B, reg_W_addr;
    input wire[4:0] display;
    input wire [31:0] wdata;
    output wire[31:0] rdata_A, rdata_B;
    output wire[31:0] display_out;
    reg [31:0] register [1:31];
    integer i;
    // $zero is always zero
    assign rdata_A = (reg_R_addr_A == 0) ? 0 : register[reg_R_addr_A];
    assign rdata_B = (reg_R_addr_B == 0) ? 0 : register[reg_R_addr_B];
    assign display_out = (display == 0) ? 0 : register[display];

    always@(posedge clk or posedge rst) begin
      if (rst == 1) begin
        for (i = 1; i < 32; i = i + 1) begin
          register[i] <= 0;
        end 
      end else begin
          if ((reg_W_addr != 0) && (reg_we == 1)) begin
            register[reg_W_addr] <= wdata;
          end
      end
    end

endmodule
