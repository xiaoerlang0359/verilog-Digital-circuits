module ds1302_test(
	input sys_clk,
	input rst_n,
	input key1,
	inout io_data,
	output ce,
	output ds1302_clk,
	output reg [5:0] seg_sel,
	output [7:0] seg_data
);

localparam S_IDLE=3'd0;
localparam S_READ_CH=3'd1;
localparam S_READ=3'd2;
localparam S_WRITE_CH=3'd3;
localparam S_WAIT=3'd4;

reg [2:0] state,next_state;

reg [2:0] sel2;
reg [7:0] data_sel1;
reg [7:0] data_sel2;
reg [7:0] data_sel3;
reg [3:0] bin_data;
reg data_sel,read_time_req,write_time_req;
wire clk2,read_time_ack,write_time_ack,cmd_read,cmd_write,cmd_read_ack,cmd_write_ack;
wire [7:0] write_data,write_addr,read_data,read_addr;
wire [7:0] write_second,write_minute,write_hour,write_date,write_month,write_year;
wire [7:0] read_second,read_minute,read_hour,read_date,read_month,read_year;
wire CE_ctrl,wr_ack,wr_req;
wire [7:0] data_in,data_recv;
wire CPOL,CPHA;
wire [3:0] clk_div;

assign CPOL=1'b0;
assign CPHA=1'b1;
assign clk_div=4'd2;
assign write_second=8'd0;
assign write_minute=8'd0;
assign write_hour=8'd0;
assign write_date=8'd5;
assign write_month=8'd6;
assign write_year=8'h19;

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		state<=3'd0;
	else
		state<=next_state;
end

always @(*)
begin
	case (state)
	S_IDLE:next_state<=S_READ_CH;
	S_READ_CH:
		if (read_time_ack==1'b1 && read_second[7]==1'b1)
			next_state<=S_WRITE_CH;
		else if (read_time_ack==1'b1 && read_second[7]==1'b0)
			next_state<=S_READ;
		else next_state<=S_READ_CH;
	S_READ:
		if (read_time_ack==1'b1)
			next_state<=S_IDLE;
		else 
			next_state<=S_READ;
	S_WRITE_CH:
		if (write_time_ack==1'b1)
			next_state<=S_WAIT;
		else next_state<=S_WRITE_CH;
	S_WAIT: next_state<=S_READ;
	default: next_state<=S_IDLE;
	endcase
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		read_time_req<=1'b0;
	else
		if (next_state==S_READ || next_state==S_READ_CH)
			read_time_req<=1'b1;
		else read_time_req<=1'b0;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		write_time_req<=1'b0;
	else
		if (next_state==S_WRITE_CH)
			write_time_req<=1'b1;
		else write_time_req<=1'b0;
end

always @(posedge key1 or negedge rst_n)
begin
	if (rst_n==1'b0)
		data_sel<=1'b0;
	else 
		data_sel<=~data_sel;
end

always @(data_sel)
begin
	if (data_sel==1'b1)
	begin
		data_sel1<=read_second;
		data_sel2<=read_minute;
		data_sel3<=read_hour;
	end
	else
	begin
		data_sel1<=read_date;
		data_sel2<=read_month;
		data_sel3<=read_year;
	end
end

always @(posedge clk2 or negedge rst_n)
begin
	if (rst_n == 1'b0)
		sel2<=3'd1;
	else
		if (sel2==4'd6)
			sel2<=3'd1;
		else 
			sel2<=sel2+3'd1;
end

always @(sel2)
begin
	case(sel2)
	3'd1: 
	begin
		seg_sel <= 6'b111110;
		bin_data<=data_sel1[3:0];
	end
	3'd2: 
	begin
		seg_sel <= 6'b111101;
		bin_data<=data_sel1[7:4];
	end
	3'd3: 
	begin
		seg_sel <= 6'b111011;
		bin_data<=data_sel2[3:0];
	end
	3'd4: 
	begin
		seg_sel <= 6'b110111;
		bin_data<=data_sel2[7:4];
	end
	3'd5: 
	begin
		seg_sel <= 6'b101111;
		bin_data<=data_sel3[3:0];
	end
	3'd6: 
	begin
		seg_sel <= 6'b011111;
		bin_data<=data_sel3[7:4];
	end
	default : 
	begin
		seg_sel <= 6'b111110;
		bin_data<=data_sel1[3:0];
	end
	endcase
end

timer timer0(.clk(sys_clk),.rst_n(rst_n),.clk2(clk2));

decode decode0(.bin_data(bin_data),.seg_data(seg_data));

di1302 di13020(
	.sys_clk(sys_clk),.rst_n(rst_n),.write_time_ack(write_time_ack),.write_time_req(write_time_req),
	.write_data(write_data),.write_addr(write_addr),.read_data(read_data),.read_addr(read_addr),
	.cmd_read(cmd_read),.cmd_write(cmd_write),.cmd_read_ack(cmd_read_ack),.cmd_write_ack(cmd_write_ack),
	.write_second(write_second),.write_minute(write_minute),.write_hour(write_hour),
	.write_date(write_date),.write_month(write_month),.write_year(write_year),
	.read_time_req(read_time_req),.read_time_ack(read_time_ack),.read_second(read_second),
	.read_minute(read_minute),.read_hour(read_hour),.read_date(read_date),.read_month(read_month),
	.read_year(read_year)
);

ds1302_io ds1302_io0(

	.ce(CE_ctrl),.data_in(data_in),.data_recv(data_recv),.wr_ack(wr_ack),
	.cmd_read(cmd_read),.cmd_write(cmd_write),.cmd_read_ack(cmd_read_ack),
	.cmd_write_ack(cmd_write_ack),.read_addr(read_addr),.write_addr(write_addr),
	.read_data(read_data),.write_data(write_data),.wr_req(wr_req)
);

spi_master spi_master0(
	.CE_ctrl(CE_ctrl),.CPHA(CPHA),.CPOL(CPOL),.clk_div(clk_div),
	.wr_req(wr_req),.data_in(data_in),.data(io_data),.CE(ce),
	.clk(ds1302_clk),.wr_ack(wr_ack),.data_recv(data_recv)
);

endmodule
