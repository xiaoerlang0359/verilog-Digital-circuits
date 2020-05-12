`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/22 22:20:28
// Design Name: 
// Module Name: exe
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module exe(
        input [31:0] Instruction,
        input [31:0] Read_data_1,
        input [31:0] Read_data_2,
        input [31:0] SignedExt_imm,
        input [3:0] AluOP,
        input AluSrcB,
        input Jal,
        input RegDst,
        input [4:0] Shamt,
        output [31:0] Alu_result,
        output [4:0] w1_num_EX
    );
    wire [31:0] A_input;
    wire [31:0] B_input;
    wire SignedCom;
    wire UnsignedCom;
    assign A_input = Read_data_1;
    assign B_input = (AluSrcB)? SignedExt_imm:Read_data_2;
    assign SignedCom = ($signed(A_input)<$signed(B_input))? 1'b1:1'b0;
    assign UnsignedCom = (A_input<B_input)? 1'b1:1'b0;
    assign Alu_result = (AluOP==4'b0000)? B_input<<Shamt:
                        (AluOP==4'b0001)? $signed(B_input)>>>Shamt:
                        (AluOP==4'b0010)? B_input>>Shamt:
                        (AluOP==4'b0101)? A_input + B_input:
                        (AluOP==4'b0110)? A_input - B_input:
                        (AluOP==4'd7)? A_input & B_input:
                        (AluOP==4'd8)? A_input | B_input:
                        (AluOP==4'd9)? A_input ^ B_input:
                        (AluOP==4'd10)? ~(A_input | B_input):
                        (AluOP==4'd11)? {31'd0,SignedCom}:
                        (AluOP==4'd12)? {31'd0,UnsignedCom}:A_input+B_input;                      
    assign w1_num_EX = (Jal)? 5'h1f:
                    (RegDst)? Instruction[15:11]: Instruction[20:16];
endmodule
