`timescale 1ns / 1ps
module Multi_CPU_sim();
    reg clk;
    reg reset;
    reg MIO_ready; // be used: =1
    reg INT; // interrupt
    reg [31:0] Data_in;
    wire [31:0] PC_out; //Test
    wire [31:0] inst_out; //TEST
    wire [31:0] jump_addr_out; // TEST
    wire mem_w; // mem write
    wire [31:0] Addr_out;
    wire [31:0] Data_out;
    wire CPU_MIO;
    wire [4:0] state;

    Multi_CPU UUT(.clk(clk), .reset(reset), .inst_out(inst_out), .INT(INT), .PC_out(PC_out), .mem_w(mem_w), .Addr_out(Addr_out), .Data_in(Data_in), .Data_out(Data_out), .state(state), .CPU_MIO(CPU_MIO), .MIO_ready(MIO_ready), .jump_addr_out(jump_addr_out));

    initial begin
      reset <= 1;
      clk <= 0;
      MIO_ready <= 1;
      INT <= 0;
      Data_in <= 0;

      #10;

      reset <= 0;

      #10;

      Data_in <= #20 32'h08000008;
      #10;
      Data_in <= #20 32'h08000000;
      #10;
    end

    integer i;
    always @*
        for (i=0; i<10; i=i+1) clk <= #5 ~clk;

endmodule
