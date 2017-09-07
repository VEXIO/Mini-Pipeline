`timescale 1ns / 1ps

module M_datapath_sim();

// Inputs
    reg clk;
    reg IorD;
    reg [2:0] ALU_operation;
    reg [1:0] ALUSrcB;
    reg ALUSrcA;
    reg RegWrite;
    reg [1:0] RegDst;
    reg Branch;
    reg [1:0] PCSource;
    reg IRWrite;
    reg [31:0] data2CPU;
    reg [1:0] MemtoReg;
    reg rst;
    reg MIO_ready;
    reg PCWrite;
    reg PCWriteCond;

// Output
    wire [31:0] Inst;
    wire overflow;
    wire zero;
    wire [31:0] PC_Current;
    wire [31:0] M_addr;
    wire [31:0] data_out;

// Bidirs

// Instantiate the UUT
    M_datapath UUT (
        .clk(clk),
        .IorD(IorD),
        .ALU_operation(ALU_operation),
        .ALUSrcB(ALUSrcB),
        .ALUSrcA(ALUSrcA),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .Branch(Branch),
        .PCSource(PCSource),
        .IRWrite(IRWrite),
        .data2CPU(data2CPU),
        .MemtoReg(MemtoReg),
        .Inst(Inst),
        .reset(rst),
        .overflow(overflow),
        .zero(zero),
        .PC_Current(PC_Current),
        .M_addr(M_addr),
        .MIO_ready(MIO_ready),
        .PCWrite(PCWrite),
        .PCWriteCond(PCWriteCond),
        .data_out(data_out)
    );
// Initialize Inputs
  `define signals{PCWrite,PCWriteCond,IorD,IRWrite,MemtoReg,PCSource,ALU_operation,ALUSrcB,ALUSrcA,RegWrite,RegDst,Branch}
integer i=0,j=0;
    initial begin
        clk = 0;
        IorD = 0;
        ALU_operation = 0;
        ALUSrcB = 0;
        ALUSrcA = 0;
        RegWrite = 0;
        RegDst = 0;
        Branch = 0;
        PCSource = 0;
        IRWrite = 0;
        data2CPU = 0;
        MemtoReg = 0;
        rst = 0;
        MIO_ready = 1;
        PCWrite = 0;
        PCWriteCond = 0;
        #1;
        //rst
        rst<=1;
        #6;
        rst<=0;
        //jump state 0->1->9->0
        //hope to jump to 0x00000010
        //around 30ns
        `signals=18'b10010000_010_0100000;
        data2CPU<=32'b000010_0000_0000_0000_0000_0000_0001_00;
        #10;
        `signals=18'b00000000_010_1100000;
        #10;
        `signals=18'b10000010_010_0000000;
        #10;

        //lw 0->1->2->3->4->0
        //hope to load 0x00000000+0x00000001 into register1	data is 0xa5a5a5a5;
        `signals=18'b10010000_010_0100000;
        data2CPU<=32'b100011_00000_00001_0000_0000_0000_0001;
        #10;
        `signals=18'b00000000_010_1100000;
        #10;
        `signals=18'b00000000_010_1010000;
        #10;
        `signals=18'b00100000_010_0000000;
        data2CPU<=32'ha5a5a5a5;
        #10;
        `signals=18'b00000100_010_0001000;
        #10;
        //lw 0->1->2->3->4->0
        //hope to load 0x00000000+0x00000001 into register2	data is 0xa5a5a5a5;
        `signals=18'b10010000_010_0100000;
        data2CPU<=32'b100011_00000_00010_0000_0000_0000_0001;
        #10;
        `signals=18'b00000000_010_1100000;
        #10;
        `signals=18'b00000000_010_1010000;
        #10;
        `signals=18'b00100000_010_0000000;
        data2CPU<=32'ha5a5a5a5;
        #10;
        `signals=18'b00000100_010_0001000;
        #10;
        //sw 0->1->2->5->0
        //hope to store 0xa5a5a5a5(register1) into 0x00000000+0x00000002;
        //165ns
        `signals=18'b10010000_010_0100000;
        data2CPU<=32'b101011_00000_00001_0000_0000_0000_0010;
        #10;
        `signals=18'b00000000_010_1100000;
        #10;
        `signals=18'b00000000_010_1010000;
        #10;
        `signals=18'b00100000_010_0000000;
        #10;
        //beq 0->1->8->0
        //200ns
        //compare register 1 and 2 jump to PC+0x00000008
        `signals=18'b10010000_010_0100000;
        data2CPU<=32'b000100_00001_00010_0000_0000_0000_0010;
        #10;
        `signals=18'b00000000_010_1100000;
        #10;
        `signals=18'b01000001_110_0010001;
        #10;
        //R 0->1->6->7->0
            //$0 nor $2 -> $3;	0x0000_0000 nor 0xa5a5_a5a5 = 0x5a5a_5a5a;
            `signals=18'b10010000_010_0100000;
            data2CPU<=32'b000000_00000_00010_00011_00000_100111;
            #10;
            `signals=18'b00000000_010_1100000;
            #10;
            `signals=18'b00000000_100_0010000;
            #10;
            `signals=18'b00000000_010_000101_0;
            #10;
            //$1 add $3 -> $4;	0xa5a5_a5a5 add 0x5a5a_5a5a = 0xffff_ffff;
            `signals=18'b10010000_010_0100000;
            data2CPU<=32'b000000_00001_00011_00100_00000_100000;
            #10;
            `signals=18'b00000000_010_1100000;
            #10;
            `signals=18'b00000000_010_0010000;
            #10;
            `signals=18'b00000000_010_000101_0;
            #10;
            //$4 minus $3 -> $5;	0xffff_ffff minus 0x5a5a_5a5a = 0xa5a5_a5a5;
            `signals=18'b10010000_010_0100000;
            data2CPU<=32'b000000_00100_00011_00101_00000_100010;
            #10;
            `signals=18'b00000000_010_1100000;
            #10;
            `signals=18'b00000000_110_0010000;
            #10;
            `signals=18'b00000000_010_000101_0;
            #10;
            //$3 xor $5 -> $6;	0x5a5a_5a5a xor 0xa5a5_a5a5 = 0xffff_ffff;
            `signals=18'b10010000_010_0100000;
            data2CPU<=32'b000000_00011_00101_00110_00000_100110;
            #10;
            `signals=18'b00000000_010_1100000;
            #10;
            `signals=18'b00000000_011_0010000;
            #10;
            `signals=18'b00000000_010_000101_0;
            #10;
            //$0 and $6 -> $7;	0x0000_0000 and 0xffff_ffff = 0x0000_0000;
            `signals=18'b10010000_010_0100000;
            data2CPU<=32'b000000_00000_00110_00111_00000_100100;
            #10;
            `signals=18'b00000000_010_1100000;
            #10;
            `signals=18'b00000000_000_0010000;
            #10;
            `signals=18'b00000000_010_000101_0;
            #10;
            //$2 or $3 -> $8;	0xa5a5_a5a5 or 0x5a5a_5a5a = 0xffff_ffff;
            `signals=18'b10010000_010_0100000;
            data2CPU<=32'b000000_00010_00011_01000_00000_100101;
            #10;
            `signals=18'b00000000_010_1100000;
            #10;
            `signals=18'b00000000_001_0010000;
            #10;
            `signals=18'b00000000_010_000101_0;
            #10;
            //$3 slt $2 -> $9;	0x5a5a_5a5a slt 0xa5a5_a5a5 = 0x0000_0001;
            `signals=18'b10010000_010_0100000;
            data2CPU<=32'b000000_00011_00010_01001_00000_101010;
            #10;
            `signals=18'b00000000_010_1100000;
            #10;
            `signals=18'b00000000_111_0010000;
            #10;
            `signals=18'b00000000_010_000101_0;
            #10;

        //traversal
        //487ns
        for(j=0;j<=31;j=j+1)begin
            `signals=18'b10010000_010_0100000;
            data2CPU[20:16]<=j;
            #10;
            `signals<=0;
            RegDst<=2'b00;
            #10;
        end
    end
    always @* begin
    for(i=0;i<1000;i=i+1)begin
            clk<=~clk;
            #5;
        end
    end
endmodule
