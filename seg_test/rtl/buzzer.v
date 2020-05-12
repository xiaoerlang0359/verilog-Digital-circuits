module buzzer(
	input en,
	input clk,
	input clk1,
	input rst_n,
	output pwmout
);

localparam cycle=250;
localparam load=50*1000000/cycle;
localparam duty=load/8*7;

reg [31:0] con1;
reg [31:0] con2;
reg pwmr;
assign pwmout=pwmr;

always @(posedge clk1 or negedge rst_n)
begin
	if (rst_n==1'b0) 
		con1<=32'd0;
	else
	if (con1==32'd50000000)
		con1<=32'd0;
	else
		con1<=con1+1'd1;
end

always @(posedge clk1 or negedge rst_n)
begin
	if (rst_n==1'b0)
		con2<=32'd0;
	else
	if (con2==load)
		con2<=32'd0;
	else
		con2<=con2+1'd1;
end

always @(posedge clk1 or negedge rst_n)
begin
	if (rst_n==1'b0)
		pwmr<=1'b1;
	else
	if (en==1'b1 && con1<32'd25000000)
	begin
		if (con2>duty)
			pwmr<=1'b0;
		else
			pwmr<=1'b1;
	end
	else pwmr<=1'b1;
end

endmodule
