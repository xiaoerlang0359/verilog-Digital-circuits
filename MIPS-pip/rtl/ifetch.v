`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/22 22:13:42
// Design Name: 
// Module Name: ifetch
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


module ifetch(
        output [31:0] Instruction,
        input rst,
        input clk,
        input en,
        input Jmp,
        input Jal,
        input Jr,
        input Branch,
        input [31:0] Addr_Beq,
        input [31:0] Addr_Jmp,
        input [31:0] Addr_Jr,
        output reg [31:0] PC_plus_4
    );
    wire [31:0] jadr;
    reg [31:0] pc;
    prom prom0(
        .addra(pc[11:2]),.clka(~clk),.douta(jadr)
    );
    assign Instruction = jadr;
    always @(negedge clk or negedge rst)
    begin
        if (rst==1'b0)
            PC_plus_4<=32'd0;
        else
            PC_plus_4<=pc+32'd4;
    end
  
    always @(posedge clk or negedge rst)
    begin
        if (rst==1'b0)
            pc<=32'd0;
        else
        if (!en)
            pc<=pc;
        else if (Jal|Jmp)
            pc<=Addr_Jmp;
        else if (Jr)
            pc<=Addr_Jr;
        else if (Branch)
            pc<=Addr_Beq;
        else pc<=PC_plus_4;
    end
endmodule
