module mycount
(
	input rst_n,
	input clr_n,
	input ld_n,
	input clk,
	input clk1,
	input [3:0] data,
	input [3:0] sel1,
	input [3:0] sel2,
	output pwmout,
	output wire [3:0] q
);

wire en;
wire c1;
wire c2;
wire c3;
wire c4;
wire c5;
wire c6;
wire pwmen;
reg [3:0] q0;
wire [3:0] q1;
wire [3:0] q2;
wire [3:0] q3;
wire [3:0] q4;
wire [3:0] q5;
wire [3:0] q6;
reg [3:0] data1;
reg [3:0] data2;
reg [3:0] data3;
reg [3:0] data4;
reg [3:0] data5;
reg [3:0] data6;
wire [7:0] miao;
wire [7:0] shi;
wire clr;

assign miao={q2,q1};
assign shi={q6,q5};
assign q=q0;
assign en=1'b1;
assign pwmen=((q4==4'd0) && (q3==4'd0) && (miao<shi))? 1'b1:1'b0;
assign clr=((q6==4'd2) && (q5==4'd4))? 1'b0:1'b1;
always @(*)
begin
	case(sel1)
		4'd1: data1<=data;
		4'd2: data2<=data;
		4'd3: data3<=data;
		4'd4: data4<=data;
		4'd5: data5<=data;
		4'd6: data6<=data;
		default: data1<=data1;
	endcase
end

always @(*)
begin
	case(sel2)
		4'd1: q0<=q6;
		4'd2: q0<=q5;
		4'd3: q0<=q4;
		4'd4: q0<=q3;
		4'd5: q0<=q2;
		4'd6: q0<=q1;
		default: q0<=q1;
	endcase
end

buzzer pwmbuzzer(.clk(clk),.clk1(clk1),.en(pwmen),.pwmout(pwmout),.rst_n(rst_n));


count10 con1(
	.clk(clk),.ld_n(ld_n),.clr_n(clr_n),.data(data1),.q(q1),.cn(c1),.en(en),.rst_n(rst_n)
	);

count6 con2(
	.clk(clk),.ld_n(ld_n),.clr_n(clr_n),.data(data2),.q(q2),.cn(c2),.en(c1),.rst_n(rst_n)
	);

count10 con3(
	.clk(clk),.ld_n(ld_n),.clr_n(clr_n),.data(data3),.q(q3),.cn(c3),.en(c2),.rst_n(rst_n)
	);

count6 con4(
	.clk(clk),.ld_n(ld_n),.clr_n(clr_n),.data(data4),.q(q4),.cn(c4),.en(c3),.rst_n(rst_n)
	);

count10 con5(
	.clk(clk),.ld_n(ld_n),.clr_n(clr),.data(data5),.q(q5),.cn(c5),.en(c4),.rst_n(rst_n)
	);

count6 con6(
	.clk(clk),.ld_n(ld_n),.clr_n(clr),.data(data6),.q(q6),.cn(c6),.en(c5),.rst_n(rst_n)
	);
	
endmodule
