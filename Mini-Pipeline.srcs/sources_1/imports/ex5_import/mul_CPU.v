`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:33:26 06/08/2017 
// Design Name: 
// Module Name:    mul_cpu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mul_CPU(clk, rst, pc,pc_next, state_num, display, pc_change, next_state, type_display, ALUout, instruction, display_temp);
    input wire clk, rst;
    input wire [15:0] display;
    //output wire [31:0] display_out; 
    output reg [3:0] type_display;
    output reg [31:0] instruction;
    reg [31:0] m_reg;
    output reg [31:0] ALUout;
    output wire [31:0] display_temp;
    wire zero;
    wire [31:0] sign_ext;
    wire [31:0] result;
    output wire [31:0] pc_next;
    wire [31:0] mem_input;
    wire [31:0] mem_data;
    output wire pc_change;
    wire [2:0] typeindic;
    
    wire [31:0] ALU_input_A;
    wire [31:0] ALU_input_B;

    wire [31:0] input_A;
    wire [31:0] input_B;
    reg [31:0] A;
    reg [31:0] B;
    
    /*****@#$@$****/
    output reg [31:0] pc;
    wire [31:0] jump_pc;
    output wire [2:0] state_num;
    output wire [3:0] next_state;
    wire R,I,J;
    
    
    
     wire PC_write_condition,
     PC_write,
      IorD,
      mem_read,
      mem_write,
      mem_to_reg,
      IR_write;
     wire [1:0] PC_source;
     wire [1:0] ALU_op;
     wire ALU_src_A;
     wire [1:0] ALU_src_B;
     wire reg_write;
     wire reg_dst; 
    
    wire [4:0] WriteAddress;
	 wire [31:0] w_data;
    
    assign WriteAddress = reg_dst == 1'b1 ? instruction[15:11] : instruction[20:16];    
    assign sign_ext = {{16{instruction[15]}}, instruction[15:0]};
    assign ALU_input_A = ALU_src_A ? A : pc;
    assign jump_pc = {pc[31:28], instruction[25:0], 2'b00};
    assign w_data = mem_to_reg == 1'b1 ? m_reg : ALUout;
    assign pc_change = (zero && PC_write_condition) || PC_write;
    assign mem_input = IorD == 1'b0 ? pc : ALUout;
    assign typeindic = {R,I,J};
	 
	 wire [2:0] ALUoper;
           
    mux4_1 alubmux(.I0(B), .I1(32'h4), .I2(sign_ext), .I3({sign_ext[29:0], 2'b0}), .Ctrl(ALU_src_B), .S(ALU_input_B));
    mux4_1 pcmux(.I0(result), .I1(ALUout), .I2(jump_pc), .I3(32'b0), .Ctrl(PC_source), .S(pc_next));
    multi_ctl multi_ctl(.OP(instruction[31:26]), .clk(clk), .PC_write_condition(PC_write_condition), .PC_write(PC_write), .IorD(IorD), 
.mem_read(mem_read), . mem_write(mem_write), .mem_to_reg(mem_to_reg), .IR_write(IR_write), .PC_source(PC_source[1:0]), 
.ALU_op(ALU_op), .ALU_src_A(ALU_src_A), .ALU_src_B(ALU_src_B[1:0]), .reg_write( reg_write), .reg_dst(reg_dst), .state_num(state_num), .next_status(next_state),.R(R), .I(I), .J(J));

    ALUctl ALUctl(.clk(clk), .ALUop(ALU_op), .func_code(instruction[5:0]), .ALUoper(ALUoper));
    regs rf(.clk(clk), .display(display[4:0]), .rst(rst), .reg_R_addr_A(instruction[25:21]), .reg_R_addr_B(instruction[20:16]), 
.reg_W_addr(WriteAddress), .wdata(w_data), .reg_we(reg_write), .rdata_A(input_A), .rdata_B(input_B), .display_out(display_temp));

    alu alu(.A(ALU_input_A), .B(ALU_input_B), .zero(zero), .ALU_OP(ALUoper), .res(result));
    
    RAM mem(.clka(~clk), .wea({4{mem_write}}), .addra(mem_input), .dina(B), .douta(mem_data));
    
    always @(*) begin
        case (typeindic)
            3'b100: begin type_display <= 4'b0001; end
            3'b010: begin type_display <= 4'b0010; end
            3'b001: begin type_display <= 4'b0011; end
            default : begin type_display <= 4'b0100; end
        endcase
    end
    
    always @ (*) begin
         if(IR_write == 1'b1)
             instruction <= mem_data;
    end
    always @ (posedge clk) begin
        
        m_reg <= mem_data;
        ALUout <= result;
        A <= input_A;
        B <= input_B;
    end
    always @ (posedge clk) begin
        if(pc_change)
            pc <= pc_next;
    end
    
    initial 
     pc <= 32'b0;
endmodule
