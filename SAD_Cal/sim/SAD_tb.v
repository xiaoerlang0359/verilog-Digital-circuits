
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/14 23:55:58
// Design Name: 
// Module Name: SAD_tb
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

`timescale 1ns/10ps
module SAD_tb();

parameter cyc_time = 10;
parameter DWIDTH = 8;
parameter PIPE_STAGE = 5;

reg clk,rstn;

reg [DWIDTH-1:0] din[0:15][0:15];
reg [DWIDTH-1:0] refi[0:15][0:15];
reg cal_en;
wire [DWIDTH+7:0] sad,sad_golden;
wire sad_vld;
wire sad_vld_golden;

wire [16*16*DWIDTH-1:0] din_w,ref_w;

integer y,x;
integer test_cnt;
reg [7:0] rand_val;
reg [4:0] wait_cyc;

always #(cyc_time/2.0) clk=~clk;

initial begin
	clk=0;
	rstn=0;
	cal_en=0;
	test_cnt=0;
	repeat(10) @(posedge clk); #1;
	rstn = 1; 
	
	repeat(2) @(posedge clk); #1;
	
	cal_en=1;
	for (y=0;y<=15;y=y+1)begin
		for (x=0;x<=15;x=x+1)begin
			din[y][x]=0;
			refi[y][x]=0;
		end
	end
	@(posedge clk); #1;
	
	cal_en=1;
	for (y=0;y<=15;y=y+1) begin
		for (x=0;x<=15;x=x+1) begin
			din[y][x]=0;
			refi[y][x]=8'hff;
		end
	end
	@ (posedge clk); #1;
	
	cal_en=1;
	for (y=0;y<=15;y=y+1) begin
		for (x=0;x<=15;x=x+1) begin
			din[y][x]=8'hff;
			refi[y][x]=8'hff;
		end
	end
	@ (posedge clk); #1;
	
	cal_en=1;
	for (y=0;y<=15;y=y+1) begin
		for (x=0;x<=15;x=x+1) begin
			din[y][x]=8'hff;
			refi[y][x]=0;
		end
	end
	@ (posedge clk); #1;
	
	cal_en=0;
	repeat(2) @(posedge clk); #1;
	
	$display("info: Do random test_0.");
	
	for (test_cnt=0; test_cnt<=(1<<15);test_cnt=test_cnt+1)begin
		rand_val = $random() % 256;
		for (y=0;y<15;y=y+1) begin
			for (x=0; x<=15; x=x+1) begin
				din[y][x] = $random() %256;
				refi[y][x] = $random() % 256;
			end
		end
		
		if (rand_val<=16) begin
			cal_en = 0;
		end else begin
			cal_en=1;
		end
		
		@(posedge clk); #1;
	end
	cal_en=0;
	
	$display("Info: Do random test 1.");
	for (test_cnt=0; test_cnt<=(1<<15);test_cnt=test_cnt+1)begin
		rand_val = $random() % 256;
		for (y=0;y<15;y=y+1) begin
			for (x=0; x<=15; x=x+1) begin
				din[y][x] = $random() %256;
				refi[y][x] = $random() % 256;
			end
		end
		
		if (rand_val>16) begin
			cal_en = 0;
		end else begin
			cal_en=1;
		end
		
		@(posedge clk); #1;
	end
	cal_en=0;
	
	repeat(20) @(posedge clk); #1;
	$finish();
end

generate
genvar y0,x0;
for(y0=0;y0<=15;y0=y0+1) begin :gen_scale_out
	for (x0=0;x0<=15;x0=x0+1) begin: gen_scale_in
		assign din_w[(y0*16*DWIDTH+x0*DWIDTH)+:DWIDTH]=din[y0][x0];
		assign ref_w[(y0*16*DWIDTH+x0*DWIDTH)+:DWIDTH]=refi[y0][x0];
	end
end
endgenerate

sad_model #(.DWIDTH(8),.PIPE_STAGE(8)) sad_model0(
	.din(din_w),.refi(ref_w),.cal_en(cal_en),.sad(sad_golden),
	.sad_vld(sad_vld_golden),.clk(clk),.rstn(rstn));

SAD_Cal sad_cal0(
	.sad(sad),.sad_vld(sad_vld),.dina(din_w),.refi(ref_w),
	.cal_en(cal_en),.clk(clk),.rst_n(rstn));
	
always @(posedge clk or negedge rstn)
if (~rstn) begin
end else if (sad_vld_golden)begin
	if ((sad_vld_golden!==sad_vld)||(sad_golden !== sad))begin
		#1;
		$display("Info: sad_cal sim fail.");
		$finish();
	end
end
		
endmodule
	
