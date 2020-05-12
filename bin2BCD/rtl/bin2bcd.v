`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/12 16:35:25
// Design Name: 
// Module Name: bin2bcd
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


module bin2bcd(
        output bcd_vld,
        output [16:0] bcd,
        input bin_vld,
        input [10:0] bin,
        input clk,rst_n
    );
    wire [16:0] bcd_reg_pre;
    wire [16:0] bcd_reg_q;
    wire [16:0] bcd_reg_b;
    wire [16:0] bcd_reg_s;
    wire [16:0] bcd_reg_g;
    wire [9:0] bin_reg_pre;
    wire [9:0] bin_reg_q;
    wire [9:0] bin_reg_b;
    wire [9:0] bin_reg_s;
    wire bin_vld_pre,bin_vld_q,bin_vld_b,bin_vld_s,bin_vld_g;
    assign bcd = (bin_vld_g)? bcd_reg_g:17'd0;
    assign bcd_vld = bin_vld_g;
    pre pre0(
        .bin_reg_pre(bin_reg_pre),.bcd_reg_pre(bcd_reg_pre),.bin_vld_pre(bin_vld_pre),
        .bin(bin),.bin_vld(bin_vld),
        .rst_n(rst_n),.clk(clk)
        );
    qian qian0(
        .bin_reg_q(bin_reg_q),.bcd_reg_q(bcd_reg_q),.bin_vld_q(bin_vld_q),
        .bin_reg_pre(bin_reg_pre),.bcd_reg_pre(bcd_reg_pre),.bin_vld_pre(bin_vld_pre),
        .rst_n(rst_n),.clk(clk)
        );
    bai bai0(
        .bin_reg_b(bin_reg_b),.bcd_reg_b(bcd_reg_b),.bin_vld_b(bin_vld_b),
        .bin_reg_q(bin_reg_q),.bcd_reg_q(bcd_reg_q),.bin_vld_q(bin_vld_q),
        .rst_n(rst_n),.clk(clk)
        );
    shi shi0(
        .bin_reg_s(bin_reg_s),.bcd_reg_s(bcd_reg_s),.bin_vld_s(bin_vld_s),
        .bin_reg_b(bin_reg_b),.bcd_reg_b(bcd_reg_b),.bin_vld_b(bin_vld_b),
        .rst_n(rst_n),.clk(clk)
        );
    ge ge0(
        .bcd_reg_g(bcd_reg_g),.bin_vld_g(bin_vld_g),
        .bin_reg_s(bin_reg_s),.bcd_reg_s(bcd_reg_s),.bin_vld_s(bin_vld_s),
        .rst_n(rst_n),.clk(clk)
        );
endmodule
