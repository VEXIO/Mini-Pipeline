`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:57:25 06/15/2017 
// Design Name: 
// Module Name:    decoder38 
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
module decoder38( in, out
    );
    input wire [2:0] in;
    output reg [7:0] out;
    always@(*) begin
        case(in)            
            3'h0: begin
            out <= 8'b00000001; end
            3'h1: begin
            out <= 8'b00000010; end
            3'h2: begin
            out <= 8'b00000100; end
            3'h3: begin
            out <= 8'b00001000; end
            3'h4: begin
            out <= 8'b00010000; end
            3'h5: begin
            out <= 8'b00100000; end
            3'h6: begin
            out <= 8'b01000000; end 
            3'h7: begin
            out <= 8'b10000000; end
        endcase
    end
endmodule
