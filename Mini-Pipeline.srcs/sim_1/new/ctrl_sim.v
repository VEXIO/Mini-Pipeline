`timescale 1ns / 1ps
module ctrl_sim();
    reg clk, reset;
    reg [31:0] Inst_in;
    reg zero, overflow, MIO_ready;

    wire MemRead, MemWrite;
    wire [2:0] ALU_operation;
    wire [4:0] state_out;

    wire CPU_MIO, IorD, IRWrite;
    wire [1:0] RegDst;
    wire RegWrite;
    wire [1:0] MemtoReg;
    wire ALUSrcA;
    wire [1:0] ALUSrcB, PCSource;
    wire PCWrite, PCWriteCond, Branch;

    ctrl UUT(.clk(clk), .reset(reset), .Inst_in(Inst_in), .zero(zero), .overflow(overflow), .MIO_ready(MIO_ready), .MemRead(MemRead), .MemWrite(MemWrite), .ALU_operation(ALU_operation), .state_out(state_out), .CPU_MIO(CPU_MIO), .IorD(IorD), .IRWrite(IRWrite), .RegDst(RegDst), .RegWrite(RegWrite), .MemtoReg(MemtoReg), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .PCSource(PCSource), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), .Branch(Branch));

    initial begin
        clk = 0;
        reset = 1;
        Inst_in = 32'h0;
        zero = 0;
        overflow = 0;
        MIO_ready = 1;

        #20;

        reset = 0;
        Inst_in = 32'h08000004;
    end

    integer i;
    always @* for (i=0; i<10; i=i+1) clk <= #5 ~clk;
endmodule
