`timescale 1ns/1ns
module spi_master_sim();

reg sys_clk;
reg rst_n;
reg nCS_ctrl;
reg CPOL;
reg CPHA;
reg [3:0] clk_div;
reg wr_req;
reg [7:0] data_in;
reg MISO;
wire nCS;
wire MOSI;
wire clk;
wire wr_ack;
wire [7:0] data_recv;

initial 
begin
	rst_n=1'b0;
	sys_clk=1'b0;
	nCS_ctrl=1'b0;
	CPOL=1'b0;
	CPHA=1'b1;
	clk_div=4'd1;
	wr_req=1'b1;
	MISO=1'b0;
	data_in=8'b1111_0000;
	nCS_ctrl=1'b0;
	
	#200 rst_n=1'b1;
	#1000 nCS_ctrl=1'b1;
	data_in=8'b0101_0101;
	#2000 nCS_ctrl=1'b0;
end


always #10 sys_clk=~sys_clk;

always #50 MISO=~MISO;

spi_master spi_master0(
	.sys_clk(sys_clk),.rst_n(rst_n),.nCS_ctrl(nCS_ctrl),.CPOL(CPOL),.CPHA(CPHA),
	.clk_div(clk_div),.wr_req(wr_req),.data_in(data_in),.MISO(MISO),.nCS(nCS),
	.MOSI(MOSI),.clk(clk),.wr_ack(wr_ack),.data_recv(data_recv)
);		

endmodule

