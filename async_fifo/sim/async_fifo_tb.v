`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/18 11:29:30
// Design Name: 
// Module Name: async_fifo_tb
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


module async_fifo_tb();
wire [31:0] fifo_rd_data;
reg fifo_wr_en;
reg fifo_rd_en;
wire fifo_full;
wire fifo_empty;
reg [31:0] fifo_wr_data;
wire fifo_wr_err;
wire fifo_rd_err;
reg wclk,rclk,rst_n;

async_fifo fifo0(
	.fifo_rd_data(fifo_rd_data),.fifo_empty(fifo_empty),.fifo_full(fifo_full),
	.fifo_wr_data(fifo_wr_data),.fifo_wr_en(fifo_wr_en),.fifo_rd_en(fifo_rd_en),
	.fifo_rd_err(fifo_rd_err),.fifo_wr_err(fifo_wr_err),
	.wclk(wclk),.rclk(rclk),.rst_n(rst_n));

initial #700 $finish;
initial fork
	rst_n=0; #5 rst_n=1;
join

initial begin wclk=0; forever #5 wclk=~wclk; end
initial begin rclk=0; forever #4 rclk=~rclk; end

initial begin
	fifo_wr_data=32'hffff_aaaa;
	@(posedge fifo_wr_en);
	repeat(24) @(negedge wclk) fifo_wr_data=~fifo_wr_data;
end

initial fork
	fifo_wr_en=0;
	begin #16 fifo_wr_en=1; #140 fifo_wr_en=0; end
	begin #286 fifo_wr_en=1; end
join

initial fork
	begin #0 fifo_rd_en=0; end
	begin #144 fifo_rd_en=1; #8 fifo_rd_en=0; end
	begin #196 fifo_rd_en=1; #86 fifo_rd_en=0; end
	begin #400 fifo_rd_en=1; end
join

endmodule
