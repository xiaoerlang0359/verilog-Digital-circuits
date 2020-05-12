`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/12 16:48:53
// Design Name: 
// Module Name: ge
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

module ge(
        output reg [16:0] bcd_reg_g,
        output reg bin_vld_g,
        input [16:0] bcd_reg_s,
        input [9:0] bin_reg_s,
        input bin_vld_s,
        input clk,rst_n
    );
    wire [16:0] ge;
    wire [16:0] bcd_ge;
    assign ge ={ 7'd0,bin_reg_s};
    assign bcd_ge=bcd_reg_s | ge;
    always @(posedge clk or negedge rst_n)
        if (rst_n==1'b0)
        begin
            bcd_reg_g<=17'd0;
            bin_vld_g<=1'b0;
        end else begin
            bcd_reg_g<=bcd_ge;
            bin_vld_g<=bin_vld_s;
        end                              
endmodule
