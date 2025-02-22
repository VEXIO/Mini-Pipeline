`timescale 1ns / 1ps
module Multi_CPU(
    input wire clk,
    input wire reset,
    input wire MIO_ready, // be used: =1
    input wire INT, // interrupt
    input wire [31:0] Data_in,
    output wire [31:0] PC_out, // Test
    output wire [31:0] inst_out, // TEST
    output wire [31:0] eret_out, // Test
    output wire mem_w, // mem write
    output wire [31:0] Addr_out,
    output wire [31:0] Data_out,
    output wire CPU_MIO,
    output wire [4:0] state,
    output wire [31:0] ctrl_debug
);

wire MemRead, MemWrite, IorD, IRWrite, RegWrite, ALUSrcA, PCWrite, PCWriteCond, Branch, zero, overflow;
wire [1:0] RegDst, MemtoReg, ALUSrcB, PCSource;
wire [2:0] ALU_operation;
wire [31:0] Inst;
wire [31:0] PC_Current, PC_Next, eret_addr;
wire PC_CE;
assign PC_out = PC_Current;

assign mem_w = ~MemRead & MemWrite;
assign inst_out = Inst;

assign eret_out = eret_addr;

ctrl ctrl(.clk(clk), .reset(reset), .Inst_in(Inst), .zero(zero), .overflow(overflow), .MIO_ready(MIO_ready), .INT(INT), .MemRead(MemRead), .MemWrite(MemWrite), .ALU_operation(ALU_operation), .state_out(state), .CPU_MIO(CPU_MIO), .IorD(IorD), .IRWrite(IRWrite), .RegDst(RegDst), .RegWrite(RegWrite), .MemtoReg(MemtoReg), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .PCSource(PCSource), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), .Branch(Branch), .PC_Current(PC_Current), .PC_Next(PC_Next), .eret_addr(eret_addr), .PC_CE(PC_CE), .debug(ctrl_debug));

M_datapath M_datapath(.clk(clk), .reset(reset), .MIO_ready(MIO_ready), .IorD(IorD), .IRWrite(IRWrite), .RegDst(RegDst), .RegWrite(RegWrite), .MemtoReg(MemtoReg), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .PCSource(PCSource), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), .Branch(Branch), .ALU_operation(ALU_operation), .PC_Current(PC_Current), .PC_Next(PC_Next), .eret_addr(eret_addr), .data2CPU(Data_in), .Inst(Inst), .data_out(Data_out), .M_addr(Addr_out), .zero(zero), .overflow(overflow), .PC_CE(PC_CE));

endmodule