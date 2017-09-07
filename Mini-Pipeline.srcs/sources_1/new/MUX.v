`timescale 1ns / 1ps
module MUX4T1_5(
    input wire [1:0] s,
    input wire [4:0] I0,
    input wire [4:0] I1,
    input wire [4:0] I2,
    input wire [4:0] I3,
    output wire [4:0] o
);
    assign o = s == 2'b00 ? I0 :
               s == 2'b01 ? I1 :
               s == 2'b10 ? I2 : I3;
endmodule

module MUX4T1_32(
    input wire [1:0] s,
    input wire [31:0] I0,
    input wire [31:0] I1,
    input wire [31:0] I2,
    input wire [31:0] I3,
    output wire [31:0] o
);
    assign o = s == 2'b00 ? I0 :
               s == 2'b01 ? I1 :
               s == 2'b10 ? I2 : I3;
endmodule

module MUX8T1_32(
    input wire [2:0] s,
    input wire [31:0] I0,
    input wire [31:0] I1,
    input wire [31:0] I2,
    input wire [31:0] I3,
    input wire [31:0] I4,
    input wire [31:0] I5,
    input wire [31:0] I6,
    input wire [31:0] I7,
    output reg [31:0] o
);
    always @ * begin
      case (s)
        3'b000 : o <= I0;
        3'b001 : o <= I1;
        3'b010 : o <= I2;
        3'b011 : o <= I3;
        3'b100 : o <= I4;
        3'b101 : o <= I5;
        3'b110 : o <= I6;
        3'b111 : o <= I7;
        default: o <= o;
      endcase
    end
endmodule

module MUX2T1_32(
    input wire s,
    input wire [31:0] I0,
    input wire [31:0] I1,
    output wire [31:0] o
);
    assign o = s ? I1 : I0;
endmodule