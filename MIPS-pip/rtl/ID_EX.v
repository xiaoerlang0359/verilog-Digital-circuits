`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/26 10:13:39
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input [31:0] Instruction_IF,
    input [31:0] PC_plus_4_IF,
    input [31:0] Read_data_1,
    input [31:0] Read_data_2,
    input [31:0] SignedExt_imm,
    output reg [31:0] Instruction_ID,
    output reg [31:0] PC_plus_4_ID,
    output reg [31:0] Read_data_1_ID,
    output reg [31:0] Read_data_2_ID,
    output reg [31:0] SignedExt_imm_ID,
    input MemtoReg,
    input MemWrite,
    input [3:0] AluOP,
    input AluSrcB,
    input RegWrite,
    input Jal,
    input RegDst,
    output reg MemtoReg_ID,
    output reg MemWrite_ID,
    output reg [3:0] AluOP_ID,
    output reg AluSrcB_ID,
    output reg RegWrite_ID,
    output reg Jal_ID,
    output reg RegDst_ID,
    input clk,input rst,input clear,input stall
    );
    always @(posedge clk or negedge rst)
    begin
        if (rst==1'b0)
        begin
            Instruction_ID<=32'd0;
            PC_plus_4_ID<=32'd0;
            SignedExt_imm_ID<=32'd0;
            Read_data_1_ID<=32'd0;
            Read_data_2_ID<=32'd0;
            MemtoReg_ID<=1'b0; MemWrite_ID<=1'b0;
            AluOP_ID<=4'd0; AluSrcB_ID<=1'b0;
            RegWrite_ID<=1'b0; Jal_ID<=1'b0;
            RegDst_ID<=1'b0;
        end
        else if (clear==1'b1)
        begin
            Instruction_ID<=32'd0;
            PC_plus_4_ID<=32'd0;
            SignedExt_imm_ID<=32'd0;
            Read_data_1_ID<=32'd0;
            Read_data_2_ID<=32'd0;
            MemtoReg_ID<=1'b0; MemWrite_ID<=1'b0;
            AluOP_ID<=4'd0; AluSrcB_ID<=1'b0;
            RegWrite_ID<=1'b0; Jal_ID<=1'b0;
            RegDst_ID<=1'b0;
        end
        else if (stall==1'b0)
        begin
            Instruction_ID<=Instruction_ID;
            PC_plus_4_ID<=PC_plus_4_ID;
            SignedExt_imm_ID<=SignedExt_imm_ID;
            Read_data_1_ID<=Read_data_1_ID;
            Read_data_2_ID<=Read_data_2_ID;
            MemtoReg_ID<=MemtoReg_ID; MemWrite_ID<=MemWrite_ID;
            AluOP_ID<=AluOP_ID; AluSrcB_ID<=AluSrcB_ID;
            RegWrite_ID<=RegWrite_ID; Jal_ID<=Jal_ID;
            RegDst_ID<=RegDst_ID;
        end
        else
        begin
            Instruction_ID<=Instruction_IF;
            PC_plus_4_ID<=PC_plus_4_IF;
            SignedExt_imm_ID<=SignedExt_imm;
            Read_data_1_ID<=Read_data_1;
            Read_data_2_ID<=Read_data_2;
            MemtoReg_ID<=MemtoReg; MemWrite_ID<=MemWrite;
            AluOP_ID<=AluOP; AluSrcB_ID<=AluSrcB;
            RegWrite_ID<=RegWrite; Jal_ID<=Jal;
            RegDst_ID<=RegDst;
        end
    end
endmodule
