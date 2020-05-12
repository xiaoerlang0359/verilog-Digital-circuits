`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/12 18:51:44
// Design Name: 
// Module Name: bin2bcd_sim
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


module bin2bcd_sim(
    );
    reg clk,rst_n,bin_vld;
    reg [10:0] bin;
    wire [16:0] bcd;
    wire bcd_vld;
    bin2bcd bin2bcd0(.bin(bin),.bcd(bcd),.bin_vld(bin_vld),.bcd_vld(bcd_vld),.clk(clk),.rst_n(rst_n));
    
    initial
    begin
        rst_n=0; clk=0; bin_vld=0;
        #40 rst_n=1; 
        bin=11'h020;
        #40 bin_vld=1;
        #20 bin=11'h39c;
        #20 bin=11'h79c;
    end
    always #10 clk=~clk;
endmodule
