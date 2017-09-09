`timescale 1ns / 1ps;
module char_ram_sim();
    reg [31:0] Addr_out, Data_out;
    reg [8:0] row_addr;
    reg [9:0] col_addr;
    reg rst;
    reg clk;
    reg mem_w;
    reg scan_vga;

    wire [31:0] dina, douta;
    wire dram_en, chram_en, texel_on;
    wire CHorD = Addr_out[31];
    wire [6:0] scan_res;
    wire [12:0] scan_dir;
    wire [5:0] offset;

    assign dram_en = mem_w & ~CHorD;
    assign chram_en = mem_w & CHorD;
    assign dina = Data_out;
    assign addra = CHorD ? {1'b0, Addr_out[30:0]} : {2'b0, Addr_out[31:2]};

    blk_mem_gen_0 data_ram(.addra(Addr_out[31:2]), .wea(dram_en), .dina(dina), .clka(clk), .douta(douta));
    blk_mem_gen_1 char_ram(
        .rsta(rst), .addra(Addr_out[30:0]), .wea(chram_en), .dina(dina), .clka(clk), .douta(),
        .addrb(scan_dir), .web(1'b0), .dinb(7'h0), .clkb(clk), .doutb(scan_res)
    );
    addr_to_texel addr_to_texel(.row_addr(row_addr), .col_addr(col_addr), .scan_dir(scan_dir), .offset(offset));
    texel_lookup texel_lookup(.ascii(scan_res), .offset(offset), .en(scan_res != 7'b0), .o(texel_on));

    initial begin
        clk <= 0;
        Addr_out <= 0;
        mem_w <= 0;
        rst <= 1;
        Data_out <= 32'h0;
        Addr_out <= 32'h0;
        row_addr <= 9'h0;
        col_addr <= 10'h0;
        scan_vga <= 0;
        #20;
        rst <= 0;
        Addr_out <= 32'h80000510;
        Data_out <= 32'h00000041;
        mem_w <= 1;
        #20;
        mem_w <= 0;
        row_addr <= 128;
        col_addr <= 128;
        scan_vga <= 1;
    end

    wire scan_to_new = row_addr == 136;

    integer i;
    always @ (*) begin
        for (i=0; i<10; i=i+1) clk <= #5 ~clk;
    end
    always @ (posedge clk) begin
        if (scan_vga) row_addr = row_addr + 1'b1; // use sync
    end
    always @ (posedge scan_to_new) begin
        if (scan_vga) col_addr = col_addr + 1'b1; // use sync
        if (row_addr == 136) row_addr = 128;
        if (col_addr == 136) col_addr = 128;
    end
endmodule // char_ram_sim