`timescale 1ns / 1ps
module Multi_CPU(
    input wire clk,
    input wire reset,
    input wire MIO_ready, // be used: =1
    input wire INT, // interrupt
    input wire [31:0] Data_in,
    output wire [31:0] PC_out, //Test
    output wire [31:0] inst_out, //TEST
    output wire mem_w, // mem write
    output wire [31:0] Addr_out,
    output wire [31:0] Data_out,
    output wire CPU_MIO,
    output wire [4:0] state
);

wire MemRead, MemWrite, IorD, IRWrite, RegWrite, ALUSrcA, PCWrite, PCWriteCond, Branch, zero, overflow;
wire [1:0] RegDst, MemtoReg, ALUSrcB, PCSource;
wire [2:0] ALU_operation;
wire [31:0] Inst;

assign mem_w = ~MemRead & MemWrite;
assign inst_out = Inst;

ctrl ctrl(
    .clk(clk),
    .reset(reset),
    .Inst_in(Inst),
    .zero(zero),
    .overflow(overflow),
    .MIO_ready(MIO_ready),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALU_operation(ALU_operation),
    .state_out(state),

    .CPU_MIO(CPU_MIO),
    .IorD(IorD),
    .IRWrite(IRWrite),
    .RegDst(RegDst),
    .RegWrite(RegWrite),
    .MemtoReg(MemtoReg),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .PCSource(PCSource),
    .PCWrite(PCWrite),
    .PCWriteCond(PCWriteCond),
    .Branch(Branch)
);

M_datapath M_datapath(
    .clk(clk),
    .reset(reset),
    .MIO_ready(MIO_ready),
    .IorD(IorD),
    .IRWrite(IRWrite),
    .RegDst(RegDst),
    .RegWrite(RegWrite),
    .MemtoReg(MemtoReg),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .PCSource(PCSource),
    .PCWrite(PCWrite),
    .PCWriteCond(PCWriteCond),
    .Branch(Branch),
    .ALU_operation(ALU_operation),
    .PC_Current(PC_out),
    .data2CPU(Data_in),
    .Inst(Inst),
    .data_out(Data_out),
    .M_addr(Addr_out),
    .zero(zero),
    .overflow(overflow)
);

endmodule