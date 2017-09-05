`timescale 1ns / 1ps

module Top(
    input wire clk_p,
    input wire clk_n,
    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue,
    output wire vga_h_sync,
    output wire vga_v_sync,
    output wire seg_clk,
    output wire seg_pen,
    output wire seg_do
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
        clkdiv <= clkdiv + 32'b1;

    wire [8:0] row_addr;
    wire [9:0] col_addr;
    wire rdn;
    wire [11:0] d_in = (row_addr < 9'd240) ? 12'hf00 :
                       (col_addr < 10'd320 ? 12'h0f0 : 12'h00f);

    vgac VGAUnit (.vga_clk(clk25), .clrn(1'b1), .d_in(d_in), .row_addr(row_addr), .col_addr(col_addr), .rdn(rdn), .r(vga_red), .g(vga_green), .b(vga_blue), .hs(vga_h_sync), .vs(vga_v_sync));

    seg_parallel2serial seg_parallel2serial (
        .clk(clk),  // main clock should be 200MHz
        .rst(1'b0),  // synchronous reset
        .data({clkdiv, clkdiv}),  // parallel input data
        .seg_en(1'b1),	// seg enable signal
        .busy(),  // busy flag
        .finish(),  // finish acknowledgement
        .seg_clk(seg_clk),  // serial clock
        .seg_pen(seg_pen),	// serial enable output
        .seg_dat(seg_do)  // serial output data
    );
endmodule