`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/12 16:48:53
// Design Name: 
// Module Name: qian
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


module qian(
        output reg [16:0] bcd_reg_q,
        output reg [9:0] bin_reg_q,
        output reg bin_vld_q,
        input bin_vld_pre,
        input [9:0] bin_reg_pre,
        input [16:0] bcd_reg_pre,
        input clk,rst_n
    );
    wire [16:0] qian;
    wire [16:0] bcd_qian;
    wire [9:0] bin_qian;
    assign qian = (bin_reg_pre>=10'd1000)? 17'd1:17'd0;
    assign bin_qian = (bin_reg_pre>=10'd1000)? bin_reg_pre-10'd1000:bin_reg_pre;
    assign bcd_qian = bcd_reg_pre | (qian<<12);
    always @(posedge clk or negedge rst_n)
        if (rst_n==1'b0)
        begin
            bcd_reg_q<=17'd0;
            bin_reg_q<=10'd0;
            bin_vld_q<=1'b0;
        end else begin
            bcd_reg_q<=bcd_qian;
            bin_reg_q<=bin_qian;
            bin_vld_q<=bin_vld_pre;
        end 
endmodule
