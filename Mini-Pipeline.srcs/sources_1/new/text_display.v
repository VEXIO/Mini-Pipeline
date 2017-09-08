`timescale 1ns / 1ps
module addr_to_texel(
    input [9:0] col_addr,
    input [8:0] row_addr,
    output [12:0] scan_dir,
    output [5:0] offset
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

    assign scan_dir = x_id + {y_id, 5'b0} + {y_id, 3'b0}; // x_id + y_id * 40
    assign offset = {y_os, x_os};
endmodule


module texel_lookup(
    input [6:0] ascii,
    input [5:0] offset,
    input en,
    output o
);
    wire texel_o;
    font_table font_table(.a({ascii, offset}), .d(texel_o));

    assign o = en & texel_o;
endmodule