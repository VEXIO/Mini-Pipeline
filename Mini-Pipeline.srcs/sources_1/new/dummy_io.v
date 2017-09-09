`timescale 1ns / 1ps

module dummy_rom(
    input [31:0] a,
    output [31:0] inst
);
    wire [31:0] rom [0:63];
    assign inst = rom[a[7:2]];

    assign rom[6'h00] = 32'h21080001; // s: lui $t0, 0x8000
    assign rom[6'h01] = 32'h0C000006; //    addi $t0, $zero, 0x510
    assign rom[6'h02] = 32'h00000000; //    addi $t1, $zero, 0x41
    assign rom[6'h03] = 32'h01084020; //    addi $t2, $zero, 0x1
    assign rom[6'h04] = 32'h08000009; //    addi $t3, $zero, 0x5b
    assign rom[6'h05] = 32'h00000000; //    sw $t1, ($t0)
    assign rom[6'h06] = 32'h21080010; // l: add $t1, $t1, $t2
    assign rom[6'h07] = 32'h03E00008; //    slt $t4, $t1, $t3
    assign rom[6'h08] = 32'h00000000; //    bne $t4, $t2, s
    assign rom[6'h09] = 32'h08000000; //
    assign rom[6'h0a] = 32'h00000000; //    sw $t1, ($t0)
    assign rom[6'h0b] = 32'h00000000; //    j l
endmodule

module dummy_ram(
    input clka,
    input wea,
    input [31:0] addra,
    input [31:0] dina,
    output [31:0] douta
);
    reg [31:0] ram [0:31];
    assign douta = ram[addra[6:2]];

    always @ (posedge clka) begin
        if (wea) ram[addra[6:2]] = dina;
    end

    integer i;
    initial begin
        for (i=0; i<32; i=i+1)
            ram[i] = 0;
        ram[5'h10] = 32'h00000001;
        ram[5'h11] = 32'h00000002;
        ram[5'h12] = 32'h12345678;
        ram[5'h13] = 32'hf5f5f5f5;
    end
endmodule