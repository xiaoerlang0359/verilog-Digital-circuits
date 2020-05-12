`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/12 16:48:53
// Design Name: 
// Module Name: bai
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


module bai(
        output reg [16:0] bcd_reg_b,
        output reg [9:0] bin_reg_b,
        output reg bin_vld_b,
        input [16:0] bcd_reg_q,
        input [9:0] bin_reg_q,
        input bin_vld_q,
        input clk,rst_n
    );
    wire [16:0] bai;
    wire [16:0] bcd_bai;
    wire [9:0] bin_bai;
    assign bai=(bin_reg_q>=10'd900)? 17'd9:
                (bin_reg_q>=10'd800)? 17'd8:
                (bin_reg_q>=10'd700)? 17'd7:
                (bin_reg_q>=10'd600)? 17'd6:
                (bin_reg_q>=10'd500)? 17'd5:
                (bin_reg_q>=10'd400)? 17'd4:
                (bin_reg_q>=10'd300)? 17'd3:
                (bin_reg_q>=10'd200)? 17'd2:
                (bin_reg_q>=10'd100)? 17'd1:17'd0;
    assign bin_bai=(bin_reg_q>=10'd900)? bin_reg_q-10'd900:
                (bin_reg_q>=10'd800)? bin_reg_q-10'd800:
                (bin_reg_q>=10'd700)? bin_reg_q-10'd700:
                (bin_reg_q>=10'd600)? bin_reg_q-10'd600:
                (bin_reg_q>=10'd500)? bin_reg_q-10'd500:
                (bin_reg_q>=10'd400)? bin_reg_q-10'd400:
                (bin_reg_q>=10'd300)? bin_reg_q-10'd300:
                (bin_reg_q>=10'd200)? bin_reg_q-10'd200:
                (bin_reg_q>=10'd100)? bin_reg_q-10'd100:bin_reg_q;
    assign bcd_bai=bcd_reg_q | (bai<<8);
    always @(posedge clk or negedge rst_n)
        if (rst_n==1'b0)
        begin
            bcd_reg_b<=17'd0;
            bin_reg_b<=10'd0;
            bin_vld_b<=1'b0;
        end else begin
            bcd_reg_b<=bcd_bai;
            bin_reg_b<=bin_bai;
            bin_vld_b<=bin_vld_q;
        end                              
endmodule
