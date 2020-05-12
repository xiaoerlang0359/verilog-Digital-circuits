`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/17 20:33:43
// Design Name: 
// Module Name: sync_fifo_tb
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


module sync_fifo_tb();
    wire fifo_full;
    wire fifo_empty;
    wire fifo_rd_err;
    wire fifo_wr_err;
    wire [31:0]fifo_rd_data;
    reg [31:0] fifo_wr_data;
    reg fifo_wr_en;
    reg fifo_rd_en;
    reg clk,rst_n;
    integer i,j;
    initial
    begin
        clk=0; rst_n=0;
        fifo_rd_en=0; fifo_wr_en=0;
        fifo_wr_data=0;
        repeat(5) @(posedge clk); #1;
        rst_n=1;
        repeat(2) @(posedge clk); #1;
        fifo_wr_en=1;
        repeat(9) @(posedge clk); #1;
        fifo_wr_en=0; fifo_rd_en=1;
        repeat(9) @(posedge clk); #1;
        fifo_wr_en=1; fifo_rd_en=0;
        repeat(3) @(posedge clk); #1;
        fifo_rd_en=1;
        repeat(10) @(posedge clk); #1;
        fifo_rd_en=0; fifo_wr_en=0;
        repeat(2) @(posedge clk); #1;
        $finish();
    end
    always #5 clk=~clk;
    always #10 fifo_wr_data=fifo_wr_data+1;
    sync_fifo sync_fifo0(
	   .fifo_rd_data(fifo_rd_data),.fifo_full(fifo_full),.fifo_empty(fifo_empty),
	   .fifo_rd_err(fifo_rd_err),.fifo_wr_err(fifo_wr_err),.fifo_wr_data(fifo_wr_data),
	   .fifo_wr_en(fifo_wr_en),.fifo_rd_en(fifo_rd_en),.clk(clk),.rst_n(rst_n)
    );
endmodule
