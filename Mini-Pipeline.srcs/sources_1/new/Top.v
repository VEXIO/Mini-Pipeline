`timescale 1ns / 1ps

module Top(
    input wire clk_p,
    input wire clk_n,

    input wire keyboard_clk,
    input wire keyboard_dat,

    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue,
    output wire vga_h_sync,
    output wire vga_v_sync,
    input wire RSTN,

    input wire [3:0] BTN_y,
    inout wire [4:0] BTN_x,
    input wire [15:0] SW,

    // output wire CR,
    // output wire readn,
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

    wire [15:0] SW_OK;
    wire [3:0] BTN_OK;

    wire Key_ready, CR, readn, rst;
    wire [4:0] Key_out;
    wire [3:0] Pulse;

    SAnti_jitter U9(.RSTN(RSTN), .clk(clk), .Key_y(BTN_y), .Key_x(BTN_x), .SW(SW), .readn(readn), .CR(CR), .Key_out(Key_out), .Key_ready(Key_ready), .pulse_out(Pulse), .BTN_OK(BTN_OK), .SW_OK(SW_OK), .rst(rst));

    wire keyboard_rdn, keyboard_ready, keyboard_overflow;
    wire [7:0] keyboard_data, keyboard_ascii;

    assign keyboard_rdn = 1'b0;

    wire [8:0] row_addr;
    wire [9:0] col_addr;
    wire rdn;

    wire [11:0] d_background = 12'h000;
    wire [11:0] d_font = 12'hfff;

    wire texel_on;
    wire [11:0] d_in = texel_on ? d_font : d_background;

    vgac vgac (.vga_clk(clk25), .clrn(1'b1), .d_in(d_in), .row_addr(row_addr), .col_addr(col_addr), .rdn(rdn), .r(vga_red), .g(vga_green), .b(vga_blue), .hs(vga_h_sync), .vs(vga_v_sync));

    wire CPU_clk = SW_OK[2] ? clkdiv[24] : clk50;
    wire [31:0] inst, PC, Addr_out, Data_in, Data_out;
    wire [4:0] State;
    wire mem_w, INT;

    wire [31:0] dina, douta;
    wire [9:0] addra;

    wire [31:0] SegDisplay, eret_out;
    wire [31:0] debug_keyboard, ctrl_debug;

    assign INT = keyboard_ready & SW_OK[11];

    Multi_CPU U1(.clk(CPU_clk), .reset(rst), .inst_out(inst), .INT(INT), .PC_out(PC), .mem_w(mem_w), .Addr_out(Addr_out), .Data_in(Data_in), .Data_out(Data_out), .eret_out(eret_out), .state(State), .CPU_MIO(), .MIO_ready(1'b1), .ctrl_debug(ctrl_debug));

    wire dram_en, chram_en;
    wire CHorD = Addr_out[31];
    wire KeyboardIO = Addr_out[30];
    assign dram_en = mem_w & ~CHorD & ~KeyboardIO;
    assign chram_en = mem_w & CHorD;

    ps2_keyboard ps2_keyboard(.clk(clk50), .reset(rst), .ps2_clk(keyboard_clk), .ps2_data(keyboard_dat), .rdn(~(KeyboardIO & mem_w)), .data(keyboard_data), .ready(keyboard_ready), .overflow(keyboard_overflow), .debug(debug_keyboard));

    scan_decoder scan_decoder(.scan_code(keyboard_data), .ascii(keyboard_ascii));

    blk_mem_gen_0 data_ram(.addra(Addr_out[31:2]), .wea(dram_en), .dina(dina), .clka(clk), .douta(douta));

    wire [6:0] scan_res;
    wire [12:0] scan_dir;
    wire [5:0] offset;
    blk_mem_gen_1 char_ram(.rsta(rst), .addra(Addr_out[30:0]), .wea(chram_en), .dina(dina), .clka(clk), .douta(), .rstb(rst), .addrb(scan_dir), .web(1'b0), .dinb(7'h0), .clkb(clk), .doutb(scan_res));

    assign dina = Data_out;
    assign addra = CHorD ? {1'b0, Addr_out[30:0]} : {2'b0, Addr_out[31:2]};
    assign Data_in = KeyboardIO ? {24'h0, keyboard_ascii} : douta;

    addr_to_texel addr_to_texel(.row_addr(row_addr), .col_addr(col_addr), .scan_dir(scan_dir), .offset(offset));

    texel_lookup texel_lookup(.ascii(scan_res), .offset(offset), .en(scan_res != 7'b0), .o(texel_on));

    SSeg7_Dev U6(.clk(clk), .rst(rst), .Start(clkdiv[20]), .SW0(SW_OK[0]), .flash(1'b0), .Hexs(SegDisplay), .point(8'b0), .LES(8'b1), .seg_clk(seg_clk), .seg_sout(seg_sout), .SEG_PEN(seg_pen), .seg_clrn());

    MUX8T1_32 dispMUX8T1(.s(SW_OK[7:5]), .o(SegDisplay), .I0(Data_out), .I1(Addr_out), .I2(PC), .I3(inst), .I4({keyboard_data, {8{keyboard_overflow}}, {8{KeyboardIO & Data_out[0]}}, {8{keyboard_ready}}}), .I5(debug_keyboard), .I6(eret_out), .I7({4{keyboard_ascii}}));
endmodule