`timescale 1ns / 1ps

module Top(
    input wire clk_p,
    input wire clk_n,
    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue,
    output wire vga_h_sync,
    output wire vga_v_sync,
    input wire RSTN,

    input wire [3:0] BTN_y,
    inout wire [4:0] BTN_x,
    input wire [15:0] SW,

    output wire CR,
    output wire readn,
    output wire RDY,

    output wire seg_clk,
    output wire seg_sout,
    output wire seg_pen
);

    wire clk;
    IBUFGDS #(
        .DIFF_TERM("FALSE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
        .IOSTANDARD("DEFAULT") // Specifies the I/O standard for this buffer
    ) IBUFGDS_inst (
        .O(clk),  // Clock buffer output
        .I(clk_p),  // Diff_p clock buffer input
        .IB(clk_n) // Diff_n clock buffer input
    );

    wire clk200Rev, clk100, clk50, clk25;

    clk_wiz_0 clk_divider_0(
        .clk_in1(clk),
        .clk_out1(clk200Rev),
        .clk_out2(clk100),
        .clk_out3(clk50),
        .clk_out4(clk25),
        .reset(1'b0),
        .locked()
    );

    reg [31:0] clkdiv = 32'b0;
    always @ (posedge clk)
        clkdiv <= clkdiv + 1'b1;

    wire [8:0] row_addr;
    wire [9:0] col_addr;
    wire rdn;

    wire [11:0] d_background = 12'h000;
    wire [11:0] d_font = 12'hfff;

    wire texel_on;
    text_display text_display(.row_addr(row_addr), .col_addr(col_addr), .o(texel_on));

    wire [11:0] d_in = texel_on ? d_font : d_background;

    vgac vgac (.vga_clk(clk25), .clrn(1'b1), .d_in(d_in), .row_addr(row_addr), .col_addr(col_addr), .rdn(rdn), .r(vga_red), .g(vga_green), .b(vga_blue), .hs(vga_h_sync), .vs(vga_v_sync));

    // blk_mem_gen_0 VRAM(
    //     .clka(clk), // for cpu write
    //     .wea(wea),
    //     .addra(vram_addra),
    //     .dina(dina),
    //     .douta(douta),
    //     .clkb(clk25), // for vga read only
    //     .web(wea),
    //     .addrb(vram_addra),
    //     .dinb(dina),
    //     .doutb(douta)
    // );

    wire [31:0] instruction;
    wire [31:0] pc;
    wire CPU_clk;
    wire [31:0] r_data_A, r_data_B, result;
    wire [31:0] display;
    wire [15:0] SW_OK = SW;
    wire [7:0] point;

    assign display = SW_OK[13] ? instruction : SW_OK[14] ? pc : SW_OK[1] ? {32{RSTN}} : clkdiv;
    SSeg7_Dev U6(.clk(clk), .rst(~RSTN), .Start(clkdiv[20]), .SW0(1'b1), .flash(1'b0), .Hexs(display), .point(8'b0), .LES(8'b1), .seg_clk(seg_clk), .seg_sout(seg_sout), .SEG_PEN(seg_pen), .seg_clrn());

    assign CPU_clk = SW_OK[7] ? clkdiv[31] : SW_OK[15] ? clkdiv[20] : clkdiv[25];
    mul_CPU cpu(.clk(CPU_clk), .rst(~RSTN), .display(SW_OK[15:0]), .instruction(instruction), .pc_next(pc));

endmodule