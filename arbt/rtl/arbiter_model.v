`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/16 16:26:44
// Design Name: 
// Module Name: arbiter_model
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


module arbiter_model(
    output gnt0,gnt1,gnt2,gnt3,
    input req0,req1,req2,req3,
    input rstn,clk
    );
	
	
	reg [7:0] cur_pri;
	wire reqfix0;
	wire reqfix1;
	wire reqfix2;
	wire reqfix3;
	wire [3:0] reqlist;
	assign reqlist={req3,req2,req1,req0};
	assign reqfix0=reqlist[cur_pri[1:0]];
	assign reqfix1=reqlist[cur_pri[3:2]];
	assign reqfix2=reqlist[cur_pri[5:4]];
	assign reqfix3=reqlist[cur_pri[7:6]];
	wire [2:0] gntfixid;
	assign gntfixid=(reqfix0)? 3'd0:
				(reqfix1)?	3'd1:
				(reqfix2)?	3'd2:
				(reqfix3)? 3'd3:3'd4;
	
	reg [3:0] gntlist;
	always @(posedge clk or negedge rstn)
	if (~rstn)begin
		cur_pri=8'b11100100;
		gntlist=4'd0;
	end else
	case (gntfixid)
		3'd0: begin
			gntlist[cur_pri[1:0]]<=1;
			gntlist[cur_pri[3:2]]<=0;
			gntlist[cur_pri[5:4]]<=0;
			gntlist[cur_pri[7:6]]<=0;
			cur_pri<={cur_pri[1:0],cur_pri[7:6],cur_pri[5:4],cur_pri[3:2]};
		end
		3'd1: begin
			gntlist[cur_pri[1:0]]<=0;
			gntlist[cur_pri[3:2]]<=1;
			gntlist[cur_pri[5:4]]<=0;
			gntlist[cur_pri[7:6]]<=0;
			cur_pri<={cur_pri[3:2],cur_pri[7:6],cur_pri[5:4],cur_pri[1:0]};
		end
		3'd2: begin
			gntlist[cur_pri[1:0]]<=0;
			gntlist[cur_pri[3:2]]<=0;
			gntlist[cur_pri[5:4]]<=1;
			gntlist[cur_pri[7:6]]<=0;
			cur_pri<={cur_pri[5:4],cur_pri[7:6],cur_pri[3:2],cur_pri[1:0]};
		end
		3'd3: begin
			gntlist[cur_pri[1:0]]<=0;
			gntlist[cur_pri[3:2]]<=0;
			gntlist[cur_pri[5:4]]<=0;
			gntlist[cur_pri[7:6]]<=1;
			cur_pri<=cur_pri;
		end
		default: begin
			gntlist<=4'd0;
			cur_pri<=cur_pri;
		end
	endcase
	
	assign gnt0=gntlist[0];
	assign gnt1=gntlist[1];
	assign gnt2=gntlist[2];
	assign gnt3=gntlist[3];
endmodule
