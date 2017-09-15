`timescale 1ns / 1ps

module Real_Top_Sim();
    reg clk;
    wire keyboard_clk;
    reg [7:0] keyboard_data;

    reg keyboard_ready, keyboard_overflow;
    reg rst;
    reg [15:0] SW;

    wire [3:0] vga_red;
    wire [3:0] vga_green;
    wire [3:0] vga_blue;
    wire vga_h_sync;
    wire vga_v_sync;

    initial begin
        clk = 0;
        keyboard_ready = 0;
        keyboard_overflow = 0;
        rst = 0;
        SW = 0;
        #10;
        rst = 1;
        #10;
        rst = 0;

        #10000;

        keyboard_ready = 1;
        keyboard_data = 8'h1C;

        #10000;

        keyboard_ready = 0;
        keyboard_data = 8'h1C;

        #100;
    end

    wire clk200Rev, clk100, clk50, clk25;

    reg [31:0] clkdiv = 32'b0;
    always @ (posedge clk)
        clkdiv <= clkdiv + 1'b1;

    assign clk200Rev = ~clk;
    assign clk100 = clkdiv[1];
    assign clk50 = clkdiv[2];
    assign clk25 = clkdiv[3];
    assign keyboard_clk = clk50;

    wire [15:0] SW_OK = SW;
    // wire [7:0] keyboard_data;

    wire keyboard_rdn;

    wire [8:0] row_addr;
    wire [9:0] col_addr;
    wire rdn;

    wire [11:0] d_background = 12'h000;
    wire [11:0] d_font = 12'hfff;

    wire texel_on;
    wire [11:0] d_in = texel_on ? d_font : d_background;

    vgac vgac (.vga_clk(clk), .clrn(~rst), .d_in(d_in), .row_addr(row_addr), .col_addr(col_addr), .rdn(rdn), .r(vga_red), .g(vga_green), .b(vga_blue), .hs(vga_h_sync), .vs(vga_v_sync));

    wire CPU_clk = clk50;
    wire [31:0] inst, PC, Addr_out, Data_in, Data_out;
    wire [4:0] State;
    wire mem_w, INT;

    wire [31:0] dina, douta;
    wire [9:0] addra;

    wire [31:0] SegDisplay, eret_out;
    wire [31:0] debug_keyboard, ctrl_debug;

    assign INT = keyboard_ready;

    Multi_CPU U1(.clk(CPU_clk), .reset(rst), .inst_out(inst), .INT(INT), .PC_out(PC), .mem_w(mem_w), .Addr_out(Addr_out), .Data_in(Data_in), .Data_out(Data_out), .eret_out(eret_out), .state(State), .CPU_MIO(), .MIO_ready(1'b1), .ctrl_debug(ctrl_debug));

    wire dram_en, chram_en;
    wire CHorD = Addr_out[31];
    wire KeyboardIO = Addr_out[30];
    assign dram_en = mem_w & ~CHorD & ~KeyboardIO;
    assign chram_en = mem_w & CHorD;

    // ps2_keyboard ps2_keyboard(.clk(clk50), .reset(rst), .ps2_clk(keyboard_clk), .ps2_data(keyboard_dat), .rdn(~(KeyboardIO & mem_w)), .data(keyboard_data), .ready(keyboard_ready), .overflow(keyboard_overflow), .debug(debug_keyboard));

    assign keyboard_rdn = ~(KeyboardIO & mem_w);

    blk_mem_gen_0 data_ram(.addra(Addr_out[31:2]), .wea(dram_en), .dina(dina), .clka(clk), .douta(douta));

    wire [6:0] scan_res;
    wire [12:0] scan_dir;
    wire [5:0] offset;
    blk_mem_gen_1 char_ram(.rsta(rst), .addra(Addr_out[30:0]), .wea(chram_en), .dina(dina), .clka(clk), .douta(), .rstb(rst), .addrb(scan_dir), .web(1'b0), .dinb(7'h0), .clkb(clk), .doutb(scan_res));

    assign dina = Data_out;
    assign addra = CHorD ? {1'b0, Addr_out[30:0]} : {2'b0, Addr_out[31:2]};
    assign Data_in = KeyboardIO ? {24'h0, keyboard_data} : douta;

    addr_to_texel addr_to_texel(.row_addr(row_addr), .col_addr(col_addr), .scan_dir(scan_dir), .offset(offset));

    texel_lookup texel_lookup(.ascii(scan_res), .offset(offset), .en(scan_res != 7'b0), .o(texel_on));


    integer i;
    always @ (*) begin
        for (i=0; i<10; i=i+1) begin
            clk <= #2 ~clk;
        end
    end
endmodule