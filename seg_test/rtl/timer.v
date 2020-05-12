module timer
(
	input clk,
	input rst_n,
	output  reg clk1,
	output  reg clk2
);

localparam CYCLE2 = 50000000/100/6;
localparam CYCLE1 = 25000000;

reg [31:0] con1;
reg [31:0] con2;

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
	begin
		con1 <= 32'd0;
		con2 <= 32'd0;
		clk1 <= 1'b0;
		clk2 <= 1'b0;
	end
	else
	begin
		if (con1 == CYCLE1-1)
		begin
			con1<=32'd0;
			clk1 <=~clk1;
		end
		else
		begin
			con1<=con1+32'd1;
			clk1<=clk1;
		end
		if (con2 == CYCLE2-1)
		begin
			con2<=32'd0;
			clk2 <=~clk2;
		end
		else
		begin
			con2<=con2+32'd1;
			clk2 <=clk2;
		end
	end
end

endmodule
