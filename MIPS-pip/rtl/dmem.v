`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/22 22:21:16
// Design Name: 
// Module Name: dmem
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


module dmem(
        input [31:0] Instruction,
        input [31:0] address,
        input [31:0] Store_data,
        input MemWrite,
        input Jal,
        input RegDst,
        output [4:0] w1_num_MEM,
        input clk,
        output [31:0] Mem_read_data
    );
 dram ram(
        .clka(~clk),
        .wea(MemWrite),
        .addra(address[15:2]),
        .dina(Store_data),
        .douta(Mem_read_data)
    );
    assign w1_num_MEM = (Jal)? 5'h1f:
                    (RegDst)? Instruction[15:11]: Instruction[20:16];
endmodule
