`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/18 10:15:03
// Design Name: 
// Module Name: async_fifo
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


module async_fifo(
	output reg [31:0] fifo_rd_data,
	output fifo_full,
	output fifo_empty,
	output reg fifo_rd_err,
	output reg fifo_wr_err,
	input [31:0] fifo_wr_data,
	input fifo_wr_en,
	input fifo_rd_en,
	input wclk,rclk,rst_n
    );

reg [3:0] wr_ptr,rd_ptr;
reg [3:0] wr_ptr_G,rd_ptr_G;
reg [3:0] wr_ptr_G_sync,rd_ptr_G_sync;
reg [3:0] wr_ptr_sync,rd_ptr_sync;
reg [3:0] wr_ptr_G_m,rd_ptr_G_m;
reg [31:0] fifo_mem[7:0];

always @(posedge wclk or negedge rst_n)
if (~rst_n)begin
end
else
	if (fifo_wr_en && ~fifo_full)
		fifo_mem[wr_ptr[2:0]]<=fifo_wr_data;

always @(posedge rclk or negedge rst_n)
if (~rst_n)
	fifo_rd_data<=32'd0;
else
	if (fifo_rd_en && ~fifo_empty)
		fifo_rd_data<=fifo_mem[rd_ptr[2:0]];
	else
		fifo_rd_data<=fifo_rd_data;

always @(posedge wclk or negedge rst_n)
if (~rst_n)
	wr_ptr<=4'd0;
else
	if (fifo_wr_en && ~fifo_full)
		wr_ptr<=wr_ptr+1;
	else
		wr_ptr<=wr_ptr;

always @(posedge rclk or negedge rst_n)
if (~rst_n)
	rd_ptr<=4'd0;
else 
	if (fifo_rd_en && ~fifo_empty)
		rd_ptr<=rd_ptr+1;
	else
		rd_ptr<=rd_ptr;

always @(posedge wclk or negedge rst_n)
if (~rst_n)
	wr_ptr_G<=4'd0;
else
	wr_ptr_G<=wr_ptr ^ (wr_ptr>>1);

always @(posedge rclk or negedge rst_n)
if (~rst_n)
	rd_ptr_G<=4'd0;
else
	rd_ptr_G<=rd_ptr ^ (rd_ptr>>1);

always @(posedge wclk or negedge rst_n)
if (~rst_n)
	{rd_ptr_G_sync,rd_ptr_G_m}<=8'd0;
else
	{rd_ptr_G_sync,rd_ptr_G_m}<={rd_ptr_G_m,rd_ptr_G};
	
always @(posedge rclk or negedge rst_n)
if (~rst_n)
	{wr_ptr_G_sync,wr_ptr_G_m}<=8'd0;
else
	{wr_ptr_G_sync,wr_ptr_G_m}<={wr_ptr_G_m,wr_ptr_G};

integer i;
always @(wr_ptr_G_sync)
begin
	wr_ptr_sync[3]=wr_ptr_G_sync[3];
	for (i=2;i>=0;i=i-1)
		wr_ptr_sync[i] = wr_ptr_G_sync[i]^wr_ptr_sync[i+1];
end

integer j;
always @(rd_ptr_G_sync)
begin
	rd_ptr_sync[3]=rd_ptr_G_sync[3];
	for (j=2;j>=0;j=j-1)
		rd_ptr_sync[j] = rd_ptr_G_sync[j]^rd_ptr_sync[j+1];
end

assign fifo_full = (wr_ptr[2:0]==rd_ptr_sync[2:0]) & (wr_ptr[3] ^ rd_ptr_sync[3]);
assign fifo_empty =(wr_ptr_sync==rd_ptr);
always @(posedge wclk or negedge rst_n)
if (~rst_n)
	fifo_wr_err<=0;
else
	if (fifo_full && fifo_wr_en) 
		fifo_wr_err<=1;
	else fifo_wr_err<=0;
always @(posedge wclk or negedge rst_n)
if (~rst_n)
	fifo_rd_err<=0;
else
	if (fifo_empty && fifo_rd_en) 
		fifo_rd_err<=1;
	else fifo_rd_err<=0;

endmodule


