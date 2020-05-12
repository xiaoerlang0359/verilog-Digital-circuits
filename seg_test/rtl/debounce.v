module debounce(
	input clk,
	input keyin,
	output  reg keyout
);

localparam th=50*10000; 

reg [31:0] q_reg;
reg [31:0] q_next;
wire key_reset;
wire key_add;
reg dif1;
reg dif2;

assign key_reset = dif1 ^ dif2;
assign key_add = ~(q_next == th);

always @(posedge clk)
begin
	case({key_reset,key_add})
	2'b01:q_next<=q_next+32'd1;
	2'b00:q_next<=q_next;
	default: q_next<=32'd0;
	endcase
end

always @(posedge clk)
begin
	q_reg<=q_next;
end

always @(posedge clk)
begin
	dif1<=keyin;
	dif2<=dif1;
end

always @(posedge clk)
begin
	if (q_reg==th)
		keyout<=dif2;
	else
		keyout<=keyout;
end

endmodule


	
