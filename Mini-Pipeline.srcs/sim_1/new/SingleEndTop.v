`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/09/05 11:05:42
// Design Name:
// Module Name: SingleEndTop
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


module SingleEndTop_test();
    reg clk200MHz;
    wire [3:0] vga_red, vga_green, vga_blue;
    wire vga_h_sync, vga_v_sync;

    reg [15:0] switch;
    wire led_clk, led_pen, led_do;
    wire seg_clk, seg_pen, seg_do;

    wire [4:0] btn_x;
    reg [4:0] btn_y;

    SingleEndTop UUT(
        .clk200MHz(clk200MHz),
        .vga_red(vga_red), .vga_green(vga_green), .vga_blue(vga_blue), .vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync),
        .switch(switch), .led_clk(led_clk), .led_pen(led_pen), .led_do(led_do),
        .seg_clk(seg_clk), .seg_pen(seg_pen), .seg_do(seg_do),
        .btn_x(btn_x), .btn_y(btn_y)
    );

    initial begin
        clk200MHz <= 0;
        switch <= 0;
        btn_y <= 0;
    end

    integer i;
    always @* begin
        for (i=0; i<10; i=i+1) clk200MHz <= #20 ~clk200MHz;
    end

endmodule
