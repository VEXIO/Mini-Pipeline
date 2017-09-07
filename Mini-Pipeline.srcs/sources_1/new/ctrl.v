`timescale 1ns / 1ps
module ctrl(
    input clk,
    input reset,
    input [31:0]Inst_in,
    input zero,
    input overflow,
    input MIO_ready,
    output reg MemRead,
    output reg MemWrite,
    output reg [2:0] ALU_operation,
    output [4:0] state_out,

    output reg CPU_MIO,
    output reg IorD,
    output reg IRWrite,
    output reg [1:0] RegDst,
    output reg RegWrite,
    output reg [1:0] MemtoReg,
    output reg ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg [1:0] PCSource,
    output reg PCWrite,
    output reg PCWriteCond,
    output reg Branch
);
    reg [1:0]ALUop;
    reg [3:0]Q;
    wire [3:0]D;
    wire [5:0]OP;
    wire [5:0]Fun;
    wire Rtype,LS,Ibeq,Jump,Load,Store;
    wire s0,s1,s2,s3,s4,s5,s6,s7,s8,s9;
    parameter IF=4'b0000,ID=4'b0001,Mem_Ex=4'b0010,Mem_RD=4'b0011,LW_WB=4'b0100,Mem_W=4'b0101,R_Exc=4'b0110,R_WB=4'b0111,Beq_Exc=4'b1000,J=4'b1001,Error=4'b1111;
    `define signals{PCWrite,PCWriteCond,IorD,MemRead,MemWrite,IRWrite,MemtoReg,PCSource,ALUSrcA,ALUSrcB,RegWrite,RegDst,Branch,ALUop,CPU_MIO}
    parameter value0=20'b10010100000010000000,value1=20'b00000000000110000000,
             value2=20'b00000000001100000000,value3=20'b00110000000000000001,
             value4=20'b00000001000001000000,value5=20'b00101000000000000001,
             value6=20'b00000000001000000100,value7=20'b00000000000001010000,
             value8=20'b01000000011000001010,value9=20'b10000000100000000000;
    parameter AND=3'b000,OR=3'b001,ADD=3'b010,SUB=3'b110,NOR=3'b100,SLT=3'b111,XOR=3'b011,SRL=3'b101;

    assign OP=Inst_in[31:26];
    assign Fun=Inst_in[5:0];

    assign Rtype=~|OP;
    assign LS=(OP==6'b100011||OP==6'b101011)? 1:0;
    assign Ibeq=(OP==6'b000100)? 1:0;
    assign Jump=(OP==6'b000010)? 1:0;
    assign Load=(OP==6'b100011)? 1:0;
    assign Store=(OP==6'b101011)? 1:0;

    assign s0=~|Q;
    assign s1=(Q==4'b0001);
    assign s2=(Q==4'b0010);
    assign s3=(Q==4'b0011);
    assign s4=(Q==4'b0100);
    assign s5=(Q==4'b0101);
    assign s6=(Q==4'b0110);
    assign s7=(Q==4'b0111);
    assign s8=(Q==4'b1000);
    assign s9=(Q==4'b1001);

    assign D[3]=s1&&(Ibeq||Jump);
    assign D[2]=(s1&&Rtype)||(s2&&Store)||(s3&&Load)||(s6&&Rtype);
    assign D[1]=(s1&&(Rtype||LS))||(s2&&Load)||(s6&&Rtype);
    assign D[0]=s0||(s1&&Jump)||(s2&&Load)||(s2&&Store)||(s6&&Rtype);

    assign state_out=Q;
    always @*begin
        case (Q)
            IF:`signals=value0;
            ID:`signals=value1;
            Mem_Ex:`signals=value2;
            Mem_RD:`signals=value3;
            LW_WB:`signals=value4;
            Mem_W:`signals=value5;
            R_Exc:`signals=value6;
            R_WB:`signals=value7;
            Beq_Exc:`signals=value8;
            J:`signals=value9;
            default:`signals=value0;
        endcase
    end

    always @(posedge clk or posedge reset)begin
        if(reset==1) Q<=IF;
        else Q<=D;
    end

    always @*begin
        case(ALUop)
            2'b00: ALU_operation=3'b010; //lw add
            2'b01: ALU_operation=3'b110; //sw sub
            2'b10:
                case(Fun)
                    6'b100000: ALU_operation=3'b010; //add
                    6'b100010: ALU_operation=3'b110; //sub
                    6'b100100: ALU_operation=3'b000; //and
                    6'b100101: ALU_operation=3'b001; //or
                    6'b101010: ALU_operation=3'b111; //slt
                    6'b100111: ALU_operation=3'b100; //nor
                    6'b000010: ALU_operation=3'b101; //srl
                    6'b100110: ALU_operation=3'b011; //xor
                    default: ALU_operation=3'b000;
                endcase
            2'b11: ALU_operation=3'b111;
        endcase
    end
endmodule
