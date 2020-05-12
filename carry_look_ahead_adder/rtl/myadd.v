`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/13 22:04:49
// Design Name: 
// Module Name: myadd
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


module myadd (
        output [3:0] sum,
        output cout,
        input [3:0] a,
        input [3:0] b,
        input cin
    );
    wire [3:0] p,g;
    wire [3:0] carry_chain;
    assign p = a^b;
    assign g = a&b;
    assign sum = p^{carry_chain[2:0],cin};
    assign cout = carry_chain[3];
    assign carry_chain[0] = (p[0]&cin)|g[0];
    assign carry_chain[1] = (p[1]&carry_chain[0])|g[1];
    assign carry_chain[2] = (p[2]&carry_chain[1])|g[2];
    assign carry_chain[3] = (p[3]&carry_chain[2])|g[3];
endmodule
