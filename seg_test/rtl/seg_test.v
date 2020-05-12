module seg_test(
	input clk,
	input ldin,
	input rst_n,
	input selldin,
	input seldin,
	output pwmout,
	output wire [7:0] seg_data,
	output reg [5:0] sel_data
);
wire ld,selld,seld;

debounce debounce_ld(.clk(clk),.keyin(ldin),.keyout(ld));

debounce debounce_selld(.clk(clk),.keyin(selldin),.keyout(selld));

debounce debounce_seld(.clk(clk),.keyin(seldin),.keyout(seld));

wire clk1,clk2,clr_n;
reg ld_n;
reg [3:0] sel1;
reg [3:0] sel2;
wire [3:0] q;
reg [3:0] set_data;

assign clr_n = 1'b1;

always @(negedge ld or negedge rst_n)
begin
	if (rst_n==0)
		ld_n<=1;
	else
		ld_n<=~ld_n;
end

always @(sel2)
begin
	case(sel2)
	4'd1: sel_data <= 6'b111110;
	4'd2: sel_data <= 6'b111101;
	4'd3: sel_data <= 6'b111011;
	4'd4: sel_data <= 6'b110111;
	4'd5: sel_data <= 6'b101111;
	4'd6: sel_data <= 6'b011111;
	default : sel_data <= 6'b111110;
	endcase
end

always @(negedge selld or negedge rst_n)
begin
	if (rst_n == 1'b0)
		sel1 <=1;
	else
	if (ld_n == 1'b0)
	begin
		if (sel1== 4'd6)
			sel1 <= 4'd1;
		else
			sel1 <= sel1+4'd1;
	end
	else
		sel1 <=sel1;
end

always @(negedge seld or negedge rst_n)
begin
	if (rst_n ==1'b0)
		set_data<=4'd0;
	else 
		if (ld_n == 1'b0)
			if (set_data==4'd9)
				set_data<=4'd0;
			else 
				set_data<=set_data+4'd1;
		else 
			set_data<=set_data;
end

always @(posedge clk2 or negedge rst_n)
begin
	if (rst_n == 1'b0)
		sel2<=4'd1;
	else
		if (sel2==4'd6)
			sel2<=4'd1;
		else 
			sel2<=sel2+4'd1;
end

timer timer0(.clk(clk),.clk1(clk1),.clk2(clk2),.rst_n(rst_n));

mycount mycount0
(
	.clk(clk1),.clk1(clk),.rst_n(rst_n),.ld_n(ld_n),.clr_n(clr_n),.sel1(sel1),.sel2(sel2),
	.data(set_data),.q(q),.pwmout(pwmout)
);

decode decode0
(
	.bin_data(q),.seg_data(seg_data)
);


endmodule
