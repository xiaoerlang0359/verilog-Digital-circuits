`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/17 18:21:24
// Design Name: 
// Module Name: sync_fifo
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

module sync_fifo(
	output reg [31:0] fifo_rd_data,
	output fifo_full,
	output fifo_empty,
	output reg fifo_rd_err,
	output reg fifo_wr_err,
	input [31:0] fifo_wr_data,
	input fifo_wr_en,
	input fifo_rd_en,
	input clk,rst_n
    );
	reg [31:0] fifo_mem[7:0];
	reg [3:0] fifo_wr_addr,fifo_rd_addr;
	always @(posedge clk or negedge rst_n)
	if (~rst_n)begin
	end
	else begin
		if (fifo_wr_en && ~fifo_full)
			fifo_mem[fifo_wr_addr[2:0]]<=fifo_wr_data;
	end
	
	always @(posedge clk or negedge rst_n)
	if (~rst_n)
		fifo_rd_data<=32'd0;
	else
		if (fifo_rd_en && ~fifo_empty)
			fifo_rd_data<=fifo_mem[fifo_rd_addr[2:0]];
		else 
			fifo_rd_data<=fifo_rd_data;
	
	always @(posedge clk or negedge rst_n)
	if (~rst_n)
		fifo_wr_addr<=4'd0;
	else
		if (fifo_wr_en && ~fifo_full)
			fifo_wr_addr<=fifo_wr_addr+1;
		else
			fifo_wr_addr<=fifo_wr_addr;
	
	always @(posedge clk or negedge rst_n)
	if (~rst_n)
		fifo_rd_addr<=4'd0;
	else
		if (fifo_rd_en && ~fifo_empty)
			fifo_rd_addr<=fifo_rd_addr+1;
		else
			fifo_rd_addr<=fifo_rd_addr;
	
	assign fifo_full = (fifo_wr_addr[2:0] == fifo_rd_addr[2:0])&(fifo_wr_addr[3]^fifo_rd_addr[3]);
	assign fifo_empty =(fifo_wr_addr == fifo_rd_addr);
	
	always @(posedge clk or negedge rst_n)
	if (~rst_n)begin	
		fifo_rd_err<=1'b0;
		fifo_wr_err<=1'b0;
	end else
	if (fifo_empty && fifo_rd_en)begin
		fifo_rd_err<=1'b1;
		fifo_wr_err<=1'b0;
	end else
	if (fifo_full && fifo_wr_en)begin
		fifo_wr_err<=1'b1;
		fifo_rd_err<=1'b0;
	end else begin
		fifo_wr_err<=1'b0;
		fifo_rd_err<=1'b0;
	end
	
endmodule
