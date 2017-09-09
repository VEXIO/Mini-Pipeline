`timescale 1ns / 1ps

module Sim_Top(
    input wire clk,
    input wire RSTN,
    input wire [15:0] SW,

    output wire [31:0] data_in, data_out, addr_out, inst_out, pc_out
);

    reg [31:0] clkdiv = 32'b0;
    always @ (posedge clk)
        clkdiv <= clkdiv + 1'b1;

    wire [15:0] SW_OK;
    wire [3:0] BTN_OK;

    wire CPU_clk = clk;
    //wire CPU_clk = SW_OK[2] ? clkdiv[24] : clkdiv[2];
    wire [31:0] inst, PC, Addr_out, Data_in, Data_out;
    wire [4:0] State;
    wire mem_w;
    wire INT = 0;

    wire [31:0] dina, douta, doutb;
    wire [9:0] addra;
    wire wea = 1'b1;

    wire [31:0] SegDisplay;

    wire rst = RSTN;

    assign SW_OK = SW;

    Multi_CPU U1(.clk(CPU_clk), .reset(rst), .inst_out(inst), .INT(INT), .PC_out(PC), .mem_w(mem_w), .Addr_out(Addr_out), .Data_in(data_in), .Data_out(Data_out), .state(State), .CPU_MIO(), .MIO_ready(1'b1));

    assign data_out = Data_out;
    assign addr_out = Addr_out;
    assign inst_out = inst;
    assign pc_out = PC;

    // blk_mem_gen_0 U3(.addra(addra), .wea(wea), .dina(dina), .clka(clk), .douta(douta));
    wire [31:0] rom_out;
    dummy_ram U3(.addra(addra), .wea(mem_w), .dina(dina), .clka(clk), .douta(douta));
    dummy_rom U4(.a(addra), .inst(rom_out));

    assign dina = Data_out;
    assign data_in = addra >= 7'h10 ? douta : rom_out;
    assign addra = Addr_out;
    // assign Data_in = douta;
endmodule