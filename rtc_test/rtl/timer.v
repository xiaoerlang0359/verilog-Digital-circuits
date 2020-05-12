module timer
(
	input clk,
	input rst_n,
	output  reg clk2
);

localparam CYCLE2 = 50000000/100/6;

reg [31:0] con2;

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
	begin
		con2 <= 32'd0;
		clk2 <= 1'b0;
	end
	else
	begin
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
