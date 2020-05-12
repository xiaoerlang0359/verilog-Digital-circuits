`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/12 16:48:53
// Design Name: 
// Module Name: shi
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


module shi(
        output reg [16:0] bcd_reg_s,
        output reg [9:0] bin_reg_s,
        output reg bin_vld_s,
        input [16:0] bcd_reg_b,
        input [9:0] bin_reg_b,
        input bin_vld_b,
        input clk,rst_n
    );
    wire [16:0] shi;
    wire [16:0] bcd_shi;
    wire [9:0] bin_shi;
    assign shi=(bin_reg_b>=10'd90)? 17'd9:
                (bin_reg_b>=10'd80)? 17'd8:
                (bin_reg_b>=10'd70)? 17'd7:
                (bin_reg_b>=10'd60)? 17'd6:
                (bin_reg_b>=10'd50)? 17'd5:
                (bin_reg_b>=10'd40)? 17'd4:
                (bin_reg_b>=10'd30)? 17'd3:
                (bin_reg_b>=10'd20)? 17'd2:
                (bin_reg_b>=10'd10)? 17'd1:17'd0;
    assign bin_shi=(bin_reg_b>=10'd90)? bin_reg_b-10'd90:
                (bin_reg_b>=10'd80)? bin_reg_b-10'd80:
                (bin_reg_b>=10'd70)? bin_reg_b-10'd70:
                (bin_reg_b>=10'd60)? bin_reg_b-10'd60:
                (bin_reg_b>=10'd50)? bin_reg_b-10'd50:
                (bin_reg_b>=10'd40)? bin_reg_b-10'd40:
                (bin_reg_b>=10'd30)? bin_reg_b-10'd30:
                (bin_reg_b>=10'd20)? bin_reg_b-10'd20:
                (bin_reg_b>=10'd10)? bin_reg_b-10'd10:bin_reg_b;
    assign bcd_shi=bcd_reg_b | (shi<<4);
    always @(posedge clk or negedge rst_n)
        if (rst_n==1'b0)
        begin
            bcd_reg_s<=17'd0;
            bin_reg_s<=10'd0;
            bin_vld_s<=1'b0;
        end else begin
            bcd_reg_s<=bcd_shi;
            bin_reg_s<=bin_shi;
            bin_vld_s<=bin_vld_b;
        end                              
endmodule
