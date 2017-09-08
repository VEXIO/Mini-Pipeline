`timescale 1ns / 1ps

module Top_CPU_sim();
    reg clk, RSTN;
    reg [15:0] SW;
    wire [31:0] data_in, data_out, rega, addr_out, inst_out, pc_out, jump_addr_out;
    wire [15:0] debug;

    Sim_Top UUT(.clk(clk), .RSTN(RSTN), .SW(SW), .data_in(data_in), .data_out(data_out), .rega(rega), .addr_out(addr_out), .inst_out(inst_out), .pc_out(pc_out), .jump_addr_out(jump_addr_out), .debug(debug));

    initial begin
        clk = 0;
        RSTN = 1;
        SW = 16'h0;
        #40;
        RSTN <= 0;


    end

    integer i;
    always @*
        for (i=0; i<10; i=i+1) clk <= #10 ~clk;
endmodule
