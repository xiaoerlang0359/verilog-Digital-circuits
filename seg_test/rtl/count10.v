module count10
(
	input clk,
	input [3:0] data,
	input rst_n,
	input en,
	input ld_n,
	input clr_n,
	output reg [3:0] q,
	output wire cn
	
);

always @ (posedge clk or negedge ld_n or negedge clr_n or negedge rst_n)
begin
	if (rst_n==1'b0)
		q<=4'd0;
	else
		if (clr_n ==1'b0)
			q<=4'd0;
		else 
		if (ld_n == 1'b0)
			q<=data;
		else
		if (en == 1'b1)
		begin
			if (q==4'd9)
				q<=4'd0;
			else 
				q<=q+4'd1;
		end
		else
			q<=q;
end

assign cn=(en == 1'b1 && q==4'd9)? 1'b1:1'b0;

endmodule
