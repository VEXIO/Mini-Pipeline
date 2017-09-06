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
    output wire SEG_PEN,
    // output wire seg_clrn,

    // output wire led_clrn,
    output wire led_clk,
    output wire led_sout,
    output wire LED_PEN

    // output wire [7:0] LED,
    // output wire Buzzer
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
    wire [11:0] d_background = (row_addr < 9'd240) ? 12'hf00 :
                       (col_addr < 10'd320 ? 12'h0f0 : 12'h00f);
    wire [11:0] d_font = 12'hfff;

    wire texel_on;
    text_display text_display(.row_addr(row_addr), .col_addr(col_addr), .o(texel_on));

    wire [11:0] d_in = texel_on ? d_font : d_background;

    vgac vgac (.vga_clk(clk25), .clrn(1'b1), .d_in(d_in), .row_addr(row_addr), .col_addr(col_addr), .rdn(rdn), .r(vga_red), .g(vga_green), .b(vga_blue), .hs(vga_h_sync), .vs(vga_v_sync));


    // wire wea = !clk25 & clk;
    // wire CPU_VRAM_addr = 1'b0, VGA_VRAM_addr = 1'b0,
    //      vram_addra = wea ? CPU_VRAM_addr : VGA_VRAM_addr,
    //      dina = 1'b0,
    //      douta = 1'b0;

    // blk_mem_gen_0 VRAM(
    //     .clka(clk),
    //     .rsta(1'b0),
    //     .wea(wea),
    //     .addra(vram_addra),
    //     .dina(dina),
    //     .douta(douta)
    // );



    wire [31:0] instruction;
    wire [31:0] display_temp;
    wire [31:0] pc;
    wire Clk_CPU;
    wire auto_clk;
    wire man_clk;
    wire [31:0] r_data_A, r_data_B, result;
    wire [31:0] display_out, display, cnt_display;
    wire [15:0] instrucstate;
    wire [7:0] tempo;
    wire [2:0] state_num;
    wire [15:0] SW_OK;
    wire [7:0] point;
    wire [4:0] Key_out;
    wire [3:0] button_out, Pulse;
    wire [3:0] type_display;

    pbdebounce p1(.clk_1ms(clkdiv[22]), .button(SW_OK[12]), .pbreg(man_clk));
    pbdebounce p2(.clk_1ms(clkdiv[22]), .button(SW_OK[11]), .pbreg(RSTB));
    decoder38 (.in(state_num), .out(tempo));

    assign cnt_display = SW_OK[15] ? {20'b0,clkdiv[31:20]} : {15'b0,clkdiv[31:15]};
    assign auto_clk = SW_OK[15] ? clkdiv[20] : clkdiv[25];
    assign SW_OK = SW;
    // SAnti_jitter U9(.RSTN(RSTB), .readn(readn), .clk(clk), .Key_y(BTN_y), .Key_x(BTN_x), .SW(SW), .Key_out(Key_out), .pulse_out(Pulse), .SW_OK(SW_OK), .Key_ready(RDY), .BTN_OK(button_out), .CR(CR));
    SPIO U7(.clk(clk), .rst(RSTB), .Start(clkdiv[20]), .EN(1'b1), .P_Data({SW_OK[13:0], SW_OK[15:0], SW_OK[15:14]}), .led_clk(led_clk), .led_clrn(), .led_sout(led_sout), .LED_PEN(LED_PEN));
    SSeg7_Dev U6(.clk(clk), .rst(RSTB), .Start(clkdiv[20]), .SW0(1'b1), .flash(1'b0), .Hexs(display), .point(8'b0), .LES(8'b1), .seg_clk(seg_clk), .seg_sout(seg_sout), .SEG_PEN(SEG_PEN), .seg_clrn());
    mul_CPU cpu(.clk(Clk_CPU), .rst(RSTB),.state_num(state_num), .display(SW_OK[15:0]), .instruction(instruction), .type_display(type_display), .pc_next(pc), .display_temp(display_temp));

    // assign Buzzer = 1'b1;
    // assign LED = ~{SW_OK[7], ~SW_OK[7], RSTB, tempo[4:0]};
    assign instrucstate = {cnt_display[3:0], type_display,{1'b0, state_num}, pc[3:0]};
    assign Clk_CPU = SW_OK[7] == 1'b1 ? man_clk : auto_clk;
    assign display = SW_OK[13] == 1'b1 ? instruction :
                     SW_OK[14] == 1'b1 ? pc :
                     SW_OK[6:5] == 2'b00 ? {16'b0, display_temp[15:0]} :
                     SW_OK[6:5] == 2'b01 ? {16'b0, display_temp[31:16]} :
                     SW_OK[6:5] == 2'b10 ? {16'b0, instrucstate} : 32'b0;
endmodule