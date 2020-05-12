`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/15 17:19:26
// Design Name: 
// Module Name: Arbiter
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


module arbiter(
    output reg gnt0,gnt1,gnt2,gnt3,
    input req0,req1,req2,req3,
    input rstn,clk
    );
	parameter FETCH=0;
	parameter COMP=1;
	reg [1:0] state,next_state;
	wire req;
	always @(posedge clk or negedge rstn)
	if (~rstn) state<=FETCH;
	else state<=next_state;
	
	always @(*)
	if (~rstn)
		next_state<=FETCH;
	else 
	case (state)
		FETCH: if (req) next_state<=FETCH;
				else next_state<=FETCH;
		COMP: next_state<=FETCH;
		default: next_state<=FETCH;
	endcase
	
	reg [2:0] grade0,grade1,grade2,grade3;
	wire [2:0] level0,level1,level2,level3;
	wire [1:0] hit;
	assign  level0 = (req0)? grade0:4;
	assign	level1 = (req1)? grade1:4;
	assign	level2 = (req2)? grade2:4;
	assign	level3 = (req3)? grade3:4;
	assign req = req0 | req1 | req2 | req3;
	assign hit = (level0<level1 && level0<level2 && level0<level3)? 2'd0:
				(level1<level0 && level1<level2 && level1<level3)? 2'd1:
				(level2<level0 && level2<level1 && level2<level3)? 2'd2:
				(level3<level0 && level3<level1 && level3<level2)? 2'd3:2'd0;
				
	always @(posedge clk or negedge rstn)
	if (~rstn) begin
		gnt0<=0; gnt1<=0; gnt2<=0; gnt3<=0;
		grade0<=0; grade1<=1; grade2<=2; grade3<=3;
	end else
	if (req & next_state==COMP)
		case (hit)
			2'd0: begin
				gnt0<=1; gnt1<=0; gnt2<=0; gnt3<=0;
				if (grade1>grade0) grade1<=grade1-1;
				else grade1<=grade1;
				if (grade2>grade0) grade2<=grade2-1;
				else grade2<=grade2;
				if (grade3>grade0) grade3<=grade3-1;
				else grade3<=grade3;
				end
			2'd1: begin
				gnt0<=0; gnt1<=1; gnt2<=0; gnt3<=0;
				if (grade0>grade1) grade0<=grade0-1;
				else grade0<=grade0;
				if (grade2>grade1) grade2<=grade2-1;
				else grade2<=grade2;
				if (grade3>grade1) grade3<=grade3-1;
				else grade3<=grade3;
				end
			2'd3: begin
				gnt0<=0; gnt1<=1; gnt2<=0; gnt3<=0;
				if (grade0>grade3) grade0<=grade0-1;
				else grade0<=grade0;
				if (grade2>grade3) grade2<=grade2-1;
				else grade2<=grade2;
				if (grade1>grade3) grade1<=grade1-1;
				else grade1<=grade1;
				end
			2'd2: begin
				gnt0<=0; gnt1<=0; gnt2<=1; gnt3<=0;
				if (grade0>grade2) grade0<=grade0-1;
				else grade0<=grade0;
				if (grade1>grade2) grade1<=grade1-1;
				else grade1<=grade1;
				if (grade3>grade2) grade3<=grade3-1;
				else grade3<=grade3;
				end
			default: begin
				gnt0<=0; gnt1<=0; gnt2<=1; gnt3<=0;
				grade0<=grade0;
				grade1<=grade1;
				grade3<=grade3;
				grade2<=grade2;
			end
		endcase
	else begin
		gnt0<=0; gnt1<=0; gnt2<=1; gnt3<=0;
		grade0<=grade0;
		grade1<=grade1;
		grade3<=grade3;
		grade2<=grade2;
	end
	
endmodule
