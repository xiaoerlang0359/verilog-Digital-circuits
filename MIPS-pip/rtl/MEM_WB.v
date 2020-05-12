`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/26 10:10:40
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
        input [31:0] Alu_result_EX,
        input [31:0] Mem_read_data,
        input [31:0] PC_plus_4_EX,
        input [31:0] Instruction_EX,
        output reg [31:0] Alu_result_MEM,
        output reg [31:0] Mem_read_data_MEM,
        output reg [31:0] PC_plus_4_MEM,
        output reg [31:0] Instruction_MEM,
        input Jal_EX,
        input MemtoReg_EX,
        input RegWrite_EX,
        input RegDst_EX,
        output reg Jal_MEM,
        output reg MemtoReg_MEM,
        output reg RegWrite_MEM,
        output reg RegDst_MEM,
        input clk, input rst, input clear, input stall
    );
    always @(posedge clk or negedge rst)
    begin
        if (rst==1'b0)
        begin
            Alu_result_MEM<=32'd0;
            Mem_read_data_MEM<=32'd0;
            PC_plus_4_MEM<=32'd0;
            Instruction_MEM<=32'd0;
            Jal_MEM<=1'b0;
            MemtoReg_MEM<=1'b0;
            RegWrite_MEM<=1'b0;
            RegDst_MEM<=1'b0;
        end
        else if (clear==1'b1)
        begin
            Alu_result_MEM<=32'd0;
            Mem_read_data_MEM<=32'd0;
            PC_plus_4_MEM<=32'd0;
            Instruction_MEM<=32'd0;
            Jal_MEM<=1'b0;
            MemtoReg_MEM<=1'b0;
            RegWrite_MEM<=1'b0;
            RegDst_MEM<=1'b0;
        end
        else if (stall==1'b0)
        begin
            Alu_result_MEM<=Alu_result_MEM;
            Mem_read_data_MEM<=Mem_read_data_MEM;
            PC_plus_4_MEM<=PC_plus_4_MEM;
            Instruction_MEM<=Instruction_MEM;
            Jal_MEM<=Jal_MEM;
            MemtoReg_MEM<=MemtoReg_MEM;
            RegWrite_MEM<=RegWrite_MEM;
            RegDst_MEM<=RegDst_MEM;
        end
        else
        begin
            Alu_result_MEM<=Alu_result_EX;
            Mem_read_data_MEM<=Mem_read_data;
            PC_plus_4_MEM<=PC_plus_4_EX;
            Instruction_MEM<=Instruction_EX;
            Jal_MEM<=Jal_EX;
            MemtoReg_MEM<=MemtoReg_EX;
            RegWrite_MEM<=RegWrite_EX;
            RegDst_MEM<=RegDst_EX;
        end
    end 
endmodule
