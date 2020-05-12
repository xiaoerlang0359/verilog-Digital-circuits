module ds1302_io(
	input sys_clk,
	input rst_n,
	output reg ce,
	output reg [7:0] data_in,
	input [7:0] data_recv,
	input wr_ack,
	input cmd_read,
	input cmd_write,
	output reg cmd_read_ack,
	output reg cmd_write_ack,
	input [7:0] read_addr,
	input [7:0] write_addr,
	output reg [7:0] read_data,
	input write_data,
	output reg wr_req
);

localparam S_IDLE=4'd1;
localparam S_CE_HIGH=4'd2;
localparam S_WRITE=4'd3;
localparam S_READ=4'd4;
localparam S_WRITE_ADDR=4'd5;
localparam S_WRITE_DATA=4'd6;
localparam S_READ_ADDR=4'd7;
localparam S_READ_DATA=4'd8;
localparam S_ACK=4'd9;
localparam S_CE_LOW=4'd10;

reg [3:0] state;
reg [3:0] next_state;

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		wr_req<=1'b0;
	else 
	if (next_state==S_WRITE_ADDR || next_state==S_WRITE_DATA || next_state==S_READ_ADDR)
		wr_req<=1'b1;
	else wr_req<=1'b0;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		state<=S_IDLE;
	else
		state<=next_state;
end

always @(*)
begin
	case (state)
		S_IDLE:
			if ({cmd_read,cmd_write}==2'b10 || {cmd_read,cmd_write}==2'b01)
				next_state<=S_CE_HIGH;
			else 
				next_state<=S_IDLE;
		S_CE_HIGH:
			if ({cmd_read,cmd_write}==2'b10)
				next_state<=S_READ;
			else
			if ({cmd_read,cmd_write}==2'b01)	
				next_state<=S_WRITE;
			else next_state<=S_IDLE;
		S_WRITE:
			next_state<=S_WRITE_ADDR;
		S_READ:
			next_state<=S_READ_ADDR;
		S_WRITE_ADDR:
			if (wr_ack==1'b1)
				next_state<=S_WRITE_DATA;
			else next_state<=S_WRITE_ADDR;
		S_READ_ADDR:
			if (wr_ack==1'b1)
				next_state<=S_READ_DATA;
			else next_state<=S_READ_ADDR;
		S_WRITE_DATA:
			if (wr_ack==1'b1)
				next_state<=S_ACK;
			else next_state<=S_WRITE_DATA;
		S_READ_DATA:
			if (wr_ack==1'b1)
				next_state<=S_ACK;
			else next_state<=S_READ_DATA;
		S_ACK:
			next_state<=S_CE_LOW;
		S_CE_LOW:
			next_state<=S_IDLE;
		default: next_state<=S_IDLE;
	endcase
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		ce<=1'b0;
	else if (state==S_CE_HIGH)
		ce<=1'b1;
	else if (state==S_CE_LOW)
		ce<=1'b0;
	else ce<=ce;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		data_in=8'd0;
	else
	begin
	case (next_state)
		S_WRITE_ADDR:
			data_in<=write_addr;
		S_WRITE_DATA:
			data_in<=write_data;
		S_READ_ADDR:
			data_in<=read_addr;
		default: data_in<=data_in;
	endcase
	end
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
	begin
		cmd_read_ack<=1'b0;
		cmd_write_ack<=1'b0;
	end
	else
		if (state==S_ACK)
			if (cmd_read==1'b1)
				cmd_read_ack<=1'b1;
			else
				cmd_write_ack<=1'b1;
		else 
		begin
			cmd_read_ack<=1'b0;
			cmd_write_ack<=1'b0;
		end
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		read_data<=8'd0;
	else
		if (state==S_READ_DATA && wr_ack==1'b1)
			read_data<=data_recv;
		else 
			read_data<=read_data;
end

endmodule
				
	