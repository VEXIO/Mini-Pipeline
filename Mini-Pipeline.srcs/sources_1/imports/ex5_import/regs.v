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
module regs(
    input wire clk,
    input wire rst,
    input wire [4:0] display,
    input wire [4:0] reg_R_addr_A,
    input wire [4:0] reg_R_addr_B,
    input wire [4:0] reg_W_addr,
    input wire [31:0] wdata,
    input wire reg_we,
    output wire [31:0] rdata_A,
    output wire [31:0] rdata_B
);
    reg [31:0] register [1:31];
    integer i;
    // $zero is always zero
    assign rdata_A = (reg_R_addr_A == 0) ? 0 : register[reg_R_addr_A];
    assign rdata_B = (reg_R_addr_B == 0) ? 0 : register[reg_R_addr_B];

    always@(posedge clk or posedge rst) begin
        if (rst == 1) begin
            for (i = 1; i < 32; i = i + 1)
                register[i] <= 0;
        end
        else begin
            if ((reg_W_addr != 0) && (reg_we == 1))
                register[reg_W_addr] <= wdata;
        end
    end

endmodule
