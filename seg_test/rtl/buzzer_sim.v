`timescale 1ns / 1ns
module buzzer_sim();

reg clk;
reg clk1;
reg en;
reg rst_n;
wire pwmout;

initial 
begin
	clk=1'b0;
	clk1=1'b0;
	en=1'b0;
	rst_n=1'b0;
	
	#200 rst_n=1'b1;
	#100 en=1'b1;
end

always #10 clk1=~clk1;

buzzer pwmbuzzer(.clk(clk),.clk1(clk1),.en(en),.pwmout(pwmout),.rst_n(rst_n));

endmodule