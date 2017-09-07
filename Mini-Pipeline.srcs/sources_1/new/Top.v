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

    wire [15:0] SW_OK;
    wire [3:0] BTN_OK;

    wire CPU_clk = SW_OK[2] ? clkdiv[24] : clkdiv[2];
    wire [31:0] inst, PC, Addr_out, Data_in, Data_out;
    wire [4:0] State;
    wire mem_w, INT;

    wire [31:0] dina, douta;
    wire [9:0] addra;
    wire wea;

    wire [31:0] SegDisplay;

    wire Key_ready;
    wire [4:0] Key_out;
    wire [3:0] Pulse;
    wire rst;

    wire counter_we, counter0_OUT, counter1_OUT, counter2_OUT;
    wire GPIOF0;
    wire [31:0] CPU2IO, counter_out;
    wire [1:0] counter_ch;
    wire [15:0] led_out; // dummy

    // assign SegDisplay = SW_OK[1] ? Data_out : SW_OK[2] ? PC : SW_OK[3] ? inst : SW_OK[4] ? CPU2IO : clkdiv;

    MUX8T1_32 dispMUX8T1(
        .s(SW_OK[7:5]),
        .o(SegDisplay),
        .I0(CPU2IO),
        .I1(clkdiv),
        .I2(PC),
        .I3(inst),
        .I4(),
        .I5(),
        .I6(),
        .I7()
    );

    wire CR, readn;

    SAnti_jitter U9(
        .RSTN(RSTN), .clk(clk), .Key_y(BTN_y), .Key_x(BTN_x), .SW(SW), .readn(readn), .CR(CR), .Key_out(Key_out), .Key_ready(Key_ready), .pulse_out(Pulse), .BTN_OK(BTN_OK), .SW_OK(SW_OK), .rst(rst)
    );

    SEnter_2_32 M4(.clk(clk), .Din(Key_out), .D_ready(Key_ready), .BTN(BTN_OK[2:0]), .Ctrl({SW_OK[7:5], SW_OK[15], SW_OK[0]}), .readn(readn), .Ai(), .Bi(), .blink());

    Multi_CPU U1(.clk(CPU_clk), .reset(rst), .inst_out(inst), .INT(INT), .PC_out(PC), .mem_w(mem_w), .Addr_out(Addr_out), .Data_in(Data_in), .Data_out(Data_out), .state(State), .CPU_MIO(), .MIO_ready(1'b1));

    MIO_BUS U4(.clk(clk), .rst(rst), .BTN(BTN_OK), .SW(SW_OK), .mem_w(mem_w), .addr_bus(Addr_out), .Cpu_data4bus(Data_in), .Cpu_data2bus(Data_out), .ram_data_in(dina), .data_ram_we(wea), .ram_addr(addra), .ram_data_out(douta), .counter_out(counter_out), .counter0_out(counter0_OUT), .counter1_out(counter1_OUT), .counter2_out(counter2_OUT), .counter_we(counter_we), .led_out(led_out), .GPIOf0000000_we(GPIOF0), .Peripheral_in(CPU2IO));

    Counter_x U10(.clk(clk), .rst(rst), .clk0(clkdiv[8]), .clk1(clkdiv[9]), .clk2(clkdiv[11]), .counter_we(counter_we), .counter_val(CPU2IO), .counter_ch(counter_ch), .counter0_OUT(counter0_OUT), .counter1_OUT(counter1_OUT), .counter2_OUT(counter2_OUT), .counter_out(counter_out));

    blk_mem_gen_0 U3(.addra(addra), .wea(wea), .dina(dina), .clka(clk), .douta(douta));

    SSeg7_Dev U6(.clk(clk), .rst(rst), .Start(clkdiv[20]), .SW0(SW_OK[0]), .flash(1'b0), .Hexs(SegDisplay), .point(8'b0), .LES(8'b1), .seg_clk(seg_clk), .seg_sout(seg_sout), .SEG_PEN(seg_pen), .seg_clrn());

    SPIO U7(.clk(clk), .rst(rst), .EN(GPIOF0), .Start(clkdiv[20]), .P_Data(CPU2IO), .counter_set(counter_ch), .LED_out(led_out));
endmodule