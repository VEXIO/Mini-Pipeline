`timescale 1ns / 1ps

module dummy_rom(
    input [31:0] a,
    output [31:0] inst
);
    wire [31:0] rom [0:63];
    assign inst = rom[a[7:2]];
    assign rom[6'h00] = 32'h3C080001; // s: lui $t0, 0x8000
    assign rom[6'h01] = 32'h35090003; //    addi $t0, $zero, 0x510
    assign rom[6'h02] = 32'h08000000; //    addi $t1, $zero, 0x41

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