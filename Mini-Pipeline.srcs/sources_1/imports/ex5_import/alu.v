`timescale 1ns / 1ps
module ALU(
        input [31:0] A,
        input [31:0] B,
        input [2:0] ALU_OP,
        output reg [31:0] res,
        output zero,
        output reg overflow
);
wire [31:0] res_and, res_or, res_nor, res_slt, res_xor, res_srl, nB;
// one more bit for checking overflow or underflow
wire [32:0] res_add, res_sub;
wire add_overflow, sub_overflow;
// signed extension to 33bit
wire [32:0] A_ext, B_ext, nB_ext;
parameter ONE = 32'h00000001, ZERO = 32'h00000000;
localparam WIDTH = 32;
localparam MSB   = WIDTH-1;

assign A_ext = {A[MSB], A};
assign B_ext = {B[MSB], B};
assign nB = ~B + 32'h00000001;
assign nB_ext= {nB[MSB], nB};

assign res_and = A&B;
assign res_or  = A|B;
// see http://stackoverflow.com/questions/24586842/signed-multiplication-overflow-detection-in-verilog/24587824#24587824

assign res_add = A_ext + B_ext;
assign res_sub = A_ext + nB_ext;
assign res_nor = ~res_or;
assign res_slt = (A < B) ? ONE : ZERO;
assign res_xor = A^B;
assign res_srl = B>>1;

// if the signed extention is not identical, it's overflow
assign add_overflow = res_add[WIDTH: WIDTH-1] == 2'b01 || res_add[WIDTH: WIDTH-1] == 2'b10;
assign sub_overflow = res_sub[WIDTH: WIDTH-1] == 2'b01 || res_sub[WIDTH: WIDTH-1] == 2'b10;
always @(*)
        begin
            case (ALU_OP)
                3'b000: res = res_and;
                3'b001: res = res_or;
                3'b010: res = res_add[MSB:0];
                3'b011: res = res_xor;
                3'b100: res = res_nor;
                3'b101: res = res_srl;
                3'b110: res = res_sub[MSB:0];
                3'b111: res = res_slt;
                default: res = res_add;
            endcase
        end

always @(*)
        begin
            case (ALU_OP)
                3'b010: overflow = add_overflow;
                3'b110: overflow = sub_overflow;
                default: overflow = 0;
            endcase
        end

assign zero = (A == B) ? 1'b1: 1'b0;

endmodule
