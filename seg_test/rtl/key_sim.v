`timescale 1ns / 1ns
module key_sim();
reg clk;
wire ld;
reg ldin;

initial
begin
	ldin=1'b1;
	clk=0;
	#2000000 ldin=1'b0;
	#100 ldin=1'b1;
	#100 ldin=1'b0;
	#100 ldin=1'b1;
	#100 ldin=1'b0;
end

always #10 clk=~clk;

debounce debouncekey(.clk(clk),.keyin(ldin),.keyout(ld));

endmodule
