`timescale 100ps/100ps
module spi_flash_test();
	reg sys_clk;
	reg rst_n;
	wire seg_sel1;
	wire seg_sel2;
	wire [7:0] seg_data;
	reg MISO;
	wire MOSI;
	wire spi_clk;
	wire spi_cs;
	
	initial 
	begin
		rst_n=1'b0;
		sys_clk=1'b0;
		MISO=1'b1;
		#200 rst_n=1'b1;
	end
	
	always #1 sys_clk=~sys_clk;
	
	
spi_flash spi_flash0(
	.sys_clk(sys_clk),.rst_n(rst_n),.seg_sel1(seg_sel1),.seg_sel2(seg_sel2),.seg_data(seg_data),
	.MISO(MISO),.MOSI(MOSI),.spi_clk(spi_clk),.spi_cs(spi_cs)
);

endmodule
