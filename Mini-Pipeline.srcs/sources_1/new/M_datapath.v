`timescale 1ns / 1ps
module M_datapath(
    input clk,
    input reset,
    input MIO_ready, //=1
    input IorD,
    input IRWrite,
    input [1:0] RegDst,
    input RegWrite,
    input [1:0] MemtoReg,
    input ALUSrcA,
    input [1:0] ALUSrcB,
    input [1:0] PCSource,
    input PCWrite,
    input PCWriteCond,
    input Branch,
    input [2:0] ALU_operation,
    input [31:0] data2CPU,
    output [31:0] PC_Current,
    output [31:0] Inst,
    output [31:0] data_out,
    output [31:0] M_addr,
    output zero,
    output overflow
);

wire [31:0] MDR_Q, Wt_data, rdata_A, rdata_B, res, ALU_Port_A, ALU_Port_B, ALU_Out, PC_Reg_D;
wire [31:0] Imm_32, Jump_addr, offset, PC_4, Branch_pc;
wire [15:0] Imm_16 = Inst[15:0];
wire [4:0] Wt_addr;
wire PC_CE;

assign Imm_32 = {{16{Imm_16[15]}}, Imm_16};
assign offset = {Imm_32[29:0], 2'b0};
assign Jump_addr = {PC_Current[31:28], Inst[25:0], 2'b0};
assign PC_4 = res;
assign Branch_pc = ALU_Out;
assign data_out = rdata_B;

assign PC_CE = ((zero & Branch & PCWriteCond) | PCWrite) & MIO_ready;

Reg32 IR(.clk(clk), .rst(reset), .CE(IRWrite), .D(data2CPU), .Q(Inst));
Reg32 MDR(.clk(clk), .rst(1'b0), .CE(1'b1), .D(data2CPU), .Q(MDR_Q));
Reg32 PCR(.clk(clk), .rst(reset), .CE(PC_CE), .D(PC_Reg_D), .Q(PC_Current));
Reg32 ALUR(.clk(clk), .rst(1'b0), .CE(1'b1), .D(res), .Q(ALU_Out));

Regs Regs(.clk(clk), .rst(reset), .L_S(RegWrite), .R_addr_A(Inst[25:21]), .R_addr_B(Inst[20:16]), .Wt_addr(Wt_addr), .Wt_data(Wt_data), .rdata_A(rdata_A), .rdata_B(rdata_B));

MUX4T1_5 Wt_Addr_MUX4T1(.s(RegDst), .I0(Inst[20:16]), .I1(Inst[15:11]), .I2(), .I3(), .o(Wt_addr));
MUX4T1_32 Wt_data_MUX4T1(.s(MemtoReg), .I0(ALU_Out), .I1(MDR_Q), .I2(), .I3(), .o(Wt_data));

MUX2T1_32 ALU_A_MUX2T1(.s(ALUSrcA), .I0(PC_Current), .I1(rdata_A), .o(ALU_Port_A));
MUX4T1_32 ALU_B_MUX4T1(.s(ALUSrcB), .I0(rdata_B), .I1(32'h4), .I2(Imm_32), .I3(offset), .o(ALU_Port_B));

MUX4T1_32 PC_Reg_MUX4T1(.s(PCSource), .I0(PC_4), .I1(Branch_pc), .I2(Jump_addr), .I3(), .o(PC_Reg_D));

MUX2T1_32 M_Addr_MUX2T1(.s(IorD), .I0(PC_Current), .I1(ALU_Out), .o(M_addr));

ALU_Unit U1(
    .A(ALU_Port_A),
    .B(ALU_Port_B),
    .ALU_operation(ALU_operation),
    .zero(zero),
    .res(res),
    .overflow(overflow)
);

endmodule