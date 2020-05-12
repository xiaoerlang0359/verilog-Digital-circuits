module spi_flash(
	input sys_clk,
	input rst_n,
	output reg seg_sel1,
	output reg seg_sel2,
	output reg [7:0] seg_data,
	input MISO,
	output MOSI,
	output spi_clk,
	output spi_cs
);

parameter addr0=24'h1a0000;

localparam S_IDLE=3'd1;
localparam S_READ=3'd2;
localparam S_WRITE=3'd3;
localparam S_SE=3'd4;

wire [23:0] myaddr;
wire [23:0] addr;
wire clk1;
wire clk2;
reg [7:0] cont,flash_write_data_in,mydata;
reg flash_read;
reg flash_write;
wire flash_bulk_erase;
reg flash_sector_erase;
reg [2:0] state;
reg [2:0] next_state;
reg st1;
reg st2;
wire s_ack,flash_write_data_req,data_valid;
wire flash_read_ack,flash_read_data_valid;
wire flash_write_ack,cmd_valid,CS_reg,wr_req;
wire flash_bulk_erase_ack,cmd_ack,CPOL,CPHA;
wire flash_sector_erase_ack,data_req,wr_ack;
wire [7:0] flash_read_data_out,cmd,data_in,size,ack_size;
wire [7:0] data_out,send_data,data_recv,size0,seg_data1,seg_data2;
wire [3:0] clk_div;

assign flash_bulk_erase=1'b0;
assign myaddr=addr0+cont;
assign s_ack=flash_read_ack | flash_write_ack | flash_sector_erase_ack;
assign CPOL=1'b0;
assign CPHA=1'b1;
assign size0=8'd1;
assign clk_div=4'd1;

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
	begin
		st1<=1'b0;
		st2<=1'b0;
	end
	else
	begin
		st1<=clk1;
		st2<=st1;
	end
end

always @(posedge clk1 or negedge rst_n)
begin
	if (rst_n==1'b0)
		cont<=8'hff;
	else 
		cont<=cont+8'd1;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		state<=S_IDLE;
	else state<=next_state;
end

always @(*)
begin
	case (state)
	S_IDLE:
		if (cont==8'd0 && st1==1'b1 && st2==1'b0)
			next_state<=S_SE;
		else
		if (cont!=8'd0 && st1==1'b1 && st2==1'b0)
			next_state<=S_WRITE;
		else 
		if (cont!=8'd0 && st1==1'b0 && st2==1'b1)
			next_state<=S_READ;
		else next_state<=S_IDLE;
	S_WRITE:
		if (s_ack==1'b1) next_state<=S_IDLE;
		else next_state<=S_WRITE;
	S_READ:
		if (s_ack==1'b1) next_state<=S_IDLE;
		else next_state<=S_READ;
	S_SE:
		if (s_ack==1'b1) next_state<=S_IDLE;
		else next_state<=S_SE;
	default: next_state<=S_IDLE;
	endcase
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		flash_read<=1'b0;
	else if (next_state==S_READ )
		flash_read<=1'b1;
	else flash_read<=1'b0;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		flash_write<=1'b0;
	else if (next_state==S_WRITE)
		flash_write<=1'b1;
	else flash_write<=1'b0;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		flash_sector_erase<=1'b0;
	else if (next_state==S_SE )
		flash_sector_erase<=1'b1;
	else flash_sector_erase<=1'b0;
end			

always @(posedge clk2 or negedge rst_n)
begin 
	if (rst_n==1'b0)
	begin
		seg_sel1<=1'b1;
		seg_sel2<=1'b0;
		seg_data<=seg_data2;
	end
	else 
	begin
		if (seg_sel1==1'b0)
			seg_data<=seg_data1;
		else seg_data<=seg_data2;
		seg_sel1<=~seg_sel1;
		seg_sel2<=~seg_sel2;
	end
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		flash_write_data_in<=8'd0;
	else if (flash_write_data_req==1'b1)
		flash_write_data_in<=cont;
	else flash_write_data_in<=flash_write_data_in;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		mydata<=8'h11;
	else if (flash_read_data_valid==1'b1)
		mydata<=flash_read_data_out;
	else mydata<=mydata;
end

spi_flash_ctrl spi_flash_ctrl0(
	.sys_clk(sys_clk),.rst_n(rst_n),.flash_read(flash_read),.flash_write(flash_write),
	.flash_bulk_erase(flash_bulk_erase),.flash_sector_erase(flash_sector_erase),
	.flash_read_ack(flash_read_ack),.flash_write_ack(flash_write_ack),
	.flash_bulk_erase_ack(flash_bulk_erase_ack),.flash_sector_erase_ack(flash_sector_erase_ack),
	.flash_read_addr(myaddr),.flash_write_addr(myaddr),.flash_sector_addr(myaddr),
	.flash_write_data_in(flash_write_data_in),.flash_read_size(size0),.flash_write_size(size0),
	.flash_write_data_req(flash_write_data_req),.flash_read_data_out(flash_read_data_out),
	.flash_read_data_valid(flash_read_data_valid),.cmd(cmd),.cmd_valid(cmd_valid),
	.cmd_ack(cmd_ack),.addr(addr),.data_in(data_in),.size(size),.ack_size(ack_size),
	.data_req(data_req),.data_out(data_out),.data_valid(data_valid)
);

spi_flash_cmd spi_flash_cmd0(
	.sys_clk(sys_clk),.rst_n(rst_n),.cmd(cmd),.cmd_valid(cmd_valid),.addr(addr),
	.size(size),.ack_size(ack_size),.data_in(data_in),.ack_cmd(cmd_ack),
	.data_req(data_req),.data_out(data_out),.data_valid(data_valid),
	.CS_reg(CS_reg),.wr_req(wr_req),.wr_ack(wr_ack),
	.send_data(send_data),.data_recv(data_recv)
);

spi_master spi_master0(
	.sys_clk(sys_clk),.rst_n(rst_n),.nCS_ctrl(CS_reg),.CPOL(CPOL),.CPHA(CPHA),
	.clk_div(clk_div),.wr_req(wr_req),.data_in(send_data),.MISO(MISO),.nCS(spi_cs),
	.MOSI(MOSI),.clk(spi_clk),.wr_ack(wr_ack),.data_recv(data_recv)
);

decode decode0(
		.bin_data(mydata[3:0]),.seg_data(seg_data1)
);

decode decode1(
		.bin_data(mydata[7:4]),.seg_data(seg_data2)
);

timer timer0(.clk(sys_clk),.rst_n(rst_n),.clk1(clk1),.clk2(clk2));

endmodule
			

