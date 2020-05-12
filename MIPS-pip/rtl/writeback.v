`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/26 12:35:14
// Design Name: 
// Module Name: writeback
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


module writeback(
        input [31:0] Instruction,
        input [31:0] PC_plus_4,
        input [31:0] Mem_read_data,
        input [31:0] Alu_result,
        input Jal,
        input MemtoReg,
        input RegDst,
        output [4:0] w1_num,
        output [31:0] Reg_write_data
    );
    assign w1_num = (Jal)? 5'h1f:
                    (RegDst)? Instruction[15:11]: Instruction[20:16];
    assign Reg_write_data = (Jal)? PC_plus_4:
                            (MemtoReg)? Mem_read_data: Alu_result;
endmodule
