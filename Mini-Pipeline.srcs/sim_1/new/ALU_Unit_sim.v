`timescale 1ns / 1ps

module ALU_Unit_sim();
    // Inputs
    reg [31:0] B;
    reg [2:0] ALU_operation;
    reg [31:0] A;

    // Output
    wire [31:0] res;
    wire zero;
    wire overflow;

    // Instantiate the UUT
    ALU_Unit UUT (
        .B(B),
        .ALU_operation(ALU_operation),
        .A(A),
        .res(res),
        .zero(zero),
        .overflow(overflow)
    );
    // Initialize Inputs
    initial begin
        B = 0;
        ALU_operation = 0;
        A = 0;
        A=32'hA5A5A5A5;
        // start testing
        B=32'h5A5A5A5A;
        ALU_operation =3'b111;
        #100;
        ALU_operation =3'b110;
        #100;
        ALU_operation =3'b101;
        #100;
        ALU_operation =3'b100;
        #100;
        ALU_operation =3'b011;
        #100;
        ALU_operation =3'b010;
        #100;
        ALU_operation =3'b001;
        #100;
        ALU_operation =3'b000;
        #100;
        A=32'h01234567;
        B=32'h76543210;
        ALU_operation =3'b111;
    end
endmodule