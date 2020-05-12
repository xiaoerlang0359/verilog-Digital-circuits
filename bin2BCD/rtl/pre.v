`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/12 17:02:23
// Design Name: 
// Module Name: pre
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


module pre(
        output reg [16:0] bcd_reg_pre,
        output reg [9:0] bin_reg_pre,
        output reg bin_vld_pre,
        input bin_vld,
        input [10:0] bin,
        input clk,rst_n
    );
    wire [9:0] bin_abs;
    wire sign;
    assign sign = bin[10];
    assign bin_abs = (sign)? ((~(bin[9:0]))+1'b1):bin[9:0];
    always @(posedge clk or negedge rst_n)begin
        if (rst_n==1'b0)
        begin
            bin_vld_pre<=1'b0;
            bcd_reg_pre<=17'd0;
            bin_reg_pre<=10'd0;
        end else
        begin
            bin_vld_pre<=bin_vld;
            bin_reg_pre<=bin_abs;
            bcd_reg_pre<={sign,16'd0};
        end
    end
endmodule
