`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/09/06 11:16:53
// Design Name:
// Module Name: text_display
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module text_display(
    input [9:0] col_addr,
    input [8:0] row_addr,
    output wire o
);

    wire [9:0] text_coord_aX = 10'd160, text_coord_bX = 10'd480;
    wire [8:0] text_coord_aY = 9'd120, text_coord_bY = 9'd360;

    wire in_text_area = row_addr >= text_coord_aY
                     && row_addr < text_coord_bY
                     && col_addr >= text_coord_aX
                     && col_addr < text_coord_bX;

    wire [9:0] coord_x = col_addr - text_coord_aX;
    wire [8:0] coord_y = row_addr - text_coord_aY;

    wire [6:0] x_id = coord_x[9:3]; // coord / 8
    wire [2:0] x_os = coord_x[2:0]; // coord % 8
    wire [5:0] y_id = coord_y[8:3];
    wire [2:0] y_os = coord_y[2:0];

    wire [12:0] f_id = x_id + y_id * 80;

    wire [12:0] pos = {y_os, x_os} + 13'd4160 + {f_id[6:0], 6'b0};

    wire texel_o;
    font_table font_table(.a(pos), .d(texel_o));

    assign o = in_text_area & texel_o;

endmodule
