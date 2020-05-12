`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/26 10:14:10
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
        input [31:0] PC_plus_4_ID,
        input [31:0] Alu_result,
        input [31:0] Instruction_ID,
        input [31:0] Read_data_2_ID,
        output reg [31:0] PC_plus_4_EX,
        output reg [31:0] Alu_result_EX,
        output reg [31:0] Instruction_EX,
        output reg [31:0] Read_data_2_EX,
        input MemWrite_ID,
        input Jal_ID,
        input RegDst_ID,
        input RegWrite_ID,
        input MemtoReg_ID,
        output reg MemWrite_EX,
        output reg Jal_EX,
        output reg RegDst_EX,
        output reg RegWrite_EX,
        output reg MemtoReg_EX,
        input clk, input rst, input clear, input stall
    );
    always @(posedge clk or negedge rst)
    begin
        if (rst==1'b0)
        begin
            PC_plus_4_EX<=32'd0;
            Alu_result_EX<=32'd0;
            Instruction_EX<=32'd0;
            Read_data_2_EX<=32'd0;
            MemWrite_EX<=1'b0;
            MemtoReg_EX<=1'b0;
            Jal_EX<=1'b0;
            RegDst_EX<=1'b0;
            RegWrite_EX<=1'b0;
        end
        else if (clear==1'b1)
        begin
            PC_plus_4_EX<=32'd0;
            Alu_result_EX<=32'd0;
            Instruction_EX<=32'd0;
            Read_data_2_EX<=32'd0;
            MemWrite_EX<=1'b0;
            MemtoReg_EX<=1'b0;
            Jal_EX<=1'b0;
            RegDst_EX<=1'b0;
            RegWrite_EX<=1'b0;
        end
        else if (stall==1'b0)
        begin
            PC_plus_4_EX<=PC_plus_4_EX;
            Alu_result_EX<=Alu_result_EX;
            Instruction_EX<=Instruction_EX;
            Read_data_2_EX<=Read_data_2_EX;
            MemWrite_EX<=MemWrite_EX;
            MemtoReg_EX<=MemtoReg_EX;
            Jal_EX<=Jal_EX;
            RegDst_EX<=RegDst_EX;
            RegWrite_EX<=RegWrite_EX;
        end
        else 
        begin
            PC_plus_4_EX<=PC_plus_4_ID;
            Alu_result_EX<=Alu_result;
            Instruction_EX<=Instruction_ID;
            Read_data_2_EX<=Read_data_2_ID;
            MemWrite_EX<=MemWrite_ID;
            MemtoReg_EX<=MemtoReg_ID;
            Jal_EX<=Jal_ID;
            RegDst_EX<=RegDst_ID;
            RegWrite_EX<=RegWrite_ID;
        end
    end 
endmodule
