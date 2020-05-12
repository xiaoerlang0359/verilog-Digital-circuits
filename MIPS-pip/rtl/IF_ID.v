`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/26 10:13:39
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input [31:0] Instruction,
    output reg [31:0] Instruction_IF,
    input [31:0] PC_plus_4,
    output reg [31:0] PC_plus_4_IF,
    input stall,
    input clear,
    input clk,
    input rst
    );
    always @(posedge clk or negedge rst)
    begin
        if (rst==1'b0)
        begin
            Instruction_IF<=32'd0;
            PC_plus_4_IF<=32'd0;
        end
        else if (clear==1'b1)
        begin
            Instruction_IF<=32'd0;
            PC_plus_4_IF<=32'd0;
        end
        else if (stall==1'b0)
        begin
            Instruction_IF<=Instruction_IF;
            PC_plus_4_IF<=PC_plus_4_IF;
        end
        else begin
            Instruction_IF<=Instruction;
            PC_plus_4_IF<=PC_plus_4;
        end
    end
endmodule
