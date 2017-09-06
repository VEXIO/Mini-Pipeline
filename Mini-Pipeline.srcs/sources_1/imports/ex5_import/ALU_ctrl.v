`timescale 1ns / 1ps
module ALU_ctrl(clk, ALUop, func_code, ALUoper
);
        input wire clk;
        input wire [1:0] ALUop;
        input wire [5:0] func_code;
        output reg [2:0] ALUoper;
        always @(*) begin
            if (ALUop == 2'b10) begin
                case(func_code)
                    6'b100000: ALUoper <= 3'b010; // add
                    6'b100010: ALUoper <= 3'b110; // sub
                    6'b100100: ALUoper <= 3'b000; // and
                    6'b100101: ALUoper <= 3'b001; // or
                    6'b101010: ALUoper <= 3'b111; // slt
                    6'b100111: ALUoper <= 3'b100; // nor
                    default: ALUoper <= 3'bx;
                endcase
            end else if (ALUop == 2'b00) begin
            // LW/SW
                ALUoper <= 3'b010;
            end else if (ALUop == 2'b01) begin
            // BEQ
                ALUoper <= 3'b110;
            end else begin
                ALUoper <= 3'bx;
            end
        end

endmodule
