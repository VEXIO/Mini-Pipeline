`timescale 1ns / 1ps
module SingleEndTop(
    clk200MHz,
    vga_red, vga_green, vga_blue, vga_h_sync, vga_v_sync,
    switch, led_clk, led_pen, led_do,
    seg_clk, seg_pen, seg_do,
    btn_x, btn_y
);
    ////////////////////////////
    input clk200MHz;
    output wire [3:0] vga_red, vga_green, vga_blue;
    output wire vga_h_sync, vga_v_sync;

    input wire [15:0] switch;
    output wire led_clk, led_pen, led_do;
    output wire seg_clk, seg_pen, seg_do;

    output wire [4:0] btn_x;
    input wire [4:0] btn_y;
    ////////////////////////////

    reg [31:0] clkdiv = 32'b0;
    always @(posedge clk200MHz)
        clkdiv <= clkdiv + 32'b1;

    wire clk25MHz = clkdiv[3];
    wire [8:0] row_addr;
    wire [9:0] col_addr;
    wire [7:0] r, g, b;
    wire rdn;

    reg [23:0] d_in;
    vgac vgac (.vga_clk(clk25MHz), .clrn(1'b1), .d_in(d_in), .row_addr(row_addr), .col_addr(col_addr), .rdn(rdn), .r(r), .g(g), .b(b), .hs(vga_h_sync), .vs(vga_v_sync));
    assign vga_red = r[7:4];
    assign vga_green = g[7:4];
    assign vga_blue = b[7:4];

    always @(posedge clk200MHz) begin
        if (row_addr < 9'd240) d_in <= {8'hff, 8'h0, 8'h0};
        else if (col_addr < 10'd320) d_in <= {8'h0, 8'hff, 8'h0};
        else d_in <= {8'h0, 8'h0, 8'hff};
    end
endmodule
