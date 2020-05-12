`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/24 10:43:40
// Design Name: 
// Module Name: MIPS_sim
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


module MIPS_sim(
    );
    reg rst=1'b0;
    reg clk=1'b0;
    MIPS_1 MIPS_10(.rst(rst),.clk(clk));
    initial begin
        #1500 rst=1'b1;
    end
    always #20 clk=~clk;
endmodule
