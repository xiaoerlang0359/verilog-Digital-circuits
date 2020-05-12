`timescale 1ns/1ns
module seg_test_sim();

reg clk;
reg selld;
reg seld;
reg ld;
reg rst_n;
wire [7:0] seg_data;
wire [5:0] sel_data;

initial
begin
	rst_n=0;
	clk=0;
	selld=1;
	seld=1;
	ld=1;
	#200 rst_n=1;
end

always #10 clk=~clk;

seg_test myseg(
	.clk(clk),.rst_n(rst_n),.ld(ld),.selld(selld),.seld(seld),.seg_data(seg_data),
	.sel_data(sel_data)
);

endmodule
