`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/16 17:16:26
// Design Name: 
// Module Name: arbiter_tb
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


module arbiter_tb();
	reg clk,rstn;
	reg req0,req1,req2,req3;
	wire gnt0,gnt1,gnt2,gnt3;
	wire [3:0] gntlist;
	assign gntlist={gnt3,gnt2,gnt1,gnt0};
	initial
	begin
		clk=0; rstn=0;
		repeat(10) @(posedge clk); #1;
		rstn=1;
		repeat(2) @(posedge clk); #1;
		
		req0=1; req1=0; req2=0; req3=0;
		@(posedge gnt0); #1;
		req0=0; req1=1; req2=0; req3=0;
		@(posedge gnt1); #1;
		req0=1; req1=0; req2=1; req3=0;
		@(posedge gnt2); #1;
		req2=0; req3=1;
		@(posedge gnt3); #1;
		req3=0; req1=1;
		@(posedge gnt0); #1;
		req0=0;
		@(posedge gnt1); #1;
		req1=0;
		
		repeat(2) @(posedge clk); #1;
		$finish();
	end
	always #10 clk=~clk;
	arbiter_model arbiter0(.gnt0(gnt0),.gnt1(gnt1),.gnt2(gnt2),.gnt3(gnt3),
		.req0(req0),.req1(req1),.req2(req2),.req3(req3),.clk(clk),.rstn(rstn));
endmodule
