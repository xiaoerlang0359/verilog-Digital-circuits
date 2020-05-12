module spi_flash_cmd(
	input sys_clk,
	input rst_n,
	input [7:0] cmd,
	input cmd_valid,
	input [23:0] addr,
	input [7:0] size,
	output [7:0] ack_size,
	input [7:0] data_in,
	output ack_cmd,
	output reg data_req,
	output reg [7:0] data_out,
	output reg data_valid,
	output reg CS_reg,
	output reg wr_req,
	input wr_ack,
	output [7:0] send_data,
	input [7:0] data_recv
);

localparam WREN=8'b0000_0110;
localparam WRDI=8'b0000_0100;
localparam RDSR=8'b0000_0101;
localparam READ=8'b0000_0011;
localparam PP=8'b0000_0010;
localparam SE=8'b1101_1000;
localparam BE=8'b1100_0111;

localparam IDLE=4'd1;
localparam CMD_LATCH=4'd2;
localparam CS_LOW=4'd3;
localparam WR_CMD=4'd4;
localparam WRITE_BYTE= 4'd5;
localparam READ_BYTE=4'd6;
localparam KEEP_CS_LOW=4'd7;
localparam CS_HIGH=4'd8;
localparam CMD_ACK=4'd9;
localparam ADDR_WR=4'd10;

reg [3:0] state;
reg [3:0] next_state;
reg [7:0] cont;
reg [7:0] mysize;
reg [7:0] cmd_code;
reg [7:0] mydata;
reg [7:0] myaddr[2:0];

assign ack_size=cont;
assign ack_cmd=(state==CMD_ACK)? 1'b1:1'b0;
//assign data_valid=(state==READ_BYTE)? wr_ack:1'b0;
assign send_data=mydata;


always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		state<=IDLE;
	else 
		state<=next_state;
end

always @(*)
begin 
	case(state)
	IDLE:
		if (cmd_valid==1'b1)
			next_state<=CMD_LATCH;
		else next_state<=IDLE;
	CMD_LATCH: next_state<=CS_LOW;
	CS_LOW: next_state<=WR_CMD;
	WR_CMD: 
		if (wr_ack==1'b1)
			if (cmd_code==PP || cmd_code==SE || cmd_code==READ)
				next_state<=ADDR_WR;
			else if (cmd_code==RDSR)
				next_state<=READ_BYTE;
			else	next_state<=KEEP_CS_LOW;
		else next_state<=WR_CMD;
	ADDR_WR:
		if (cont==3)
			if (cmd_code==PP)
				next_state<=WRITE_BYTE;
			else if (cmd_code==READ)
				next_state<=READ_BYTE;
			else next_state<=KEEP_CS_LOW;
		else next_state<=ADDR_WR;
	WRITE_BYTE:
		if (cont==mysize)
			next_state<=KEEP_CS_LOW;
		else next_state<=WRITE_BYTE;
	READ_BYTE:
		if (cont==mysize)
			next_state<=KEEP_CS_LOW;
		else next_state<=READ_BYTE;
	KEEP_CS_LOW: next_state<=CS_HIGH;
	CS_HIGH: next_state<=CMD_ACK;
	CMD_ACK: next_state<=IDLE;
	default: next_state<=IDLE;
	endcase
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		cont<=8'd0;
	else
		if (next_state!=state)
			cont<=8'd0;
		else 
			if (state==ADDR_WR || state==WRITE_BYTE || state==READ_BYTE)
				if (wr_ack==1'b1)
					cont<=cont+8'd1;
				else cont<=cont;
			else cont<=cont;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		cmd_code<=8'd0;
	else if (state==CMD_LATCH)
		cmd_code<=cmd;
	else cmd_code<=cmd_code;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		CS_reg<=1'b1;
	else if (state==CS_LOW)
		CS_reg<=1'b0;
	else if (state==CS_HIGH)
		CS_reg<=1'b1;
	else CS_reg<=CS_reg;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		mysize<=8'd0;
	else if (state<=CMD_LATCH)
		mysize<=size;
	else mysize<=mysize;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		wr_req<=1'b0;
	else if (next_state==WR_CMD || next_state==ADDR_WR || next_state==WRITE_BYTE)
		wr_req<=1'b1;
	else wr_req<=1'b0;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		data_req<=1'b0;
	else if (state==WRITE_BYTE && cont<mysize && wr_ack==1'b1)
		data_req<=1'b1;
	else data_req<=1'b0;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		mydata<=8'd0;
	else if (next_state==WR_CMD)
		mydata<=cmd_code;
	else if (next_state==ADDR_WR)
		mydata<=myaddr[cont];
	else if (next_state==WRITE_BYTE && data_req==1'b1)
		mydata<=data_in;
	else mydata<=mydata;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
	begin
		myaddr[0]=0;
		myaddr[1]=0;
		myaddr[2]=0;
	end
	else if (state==CMD_LATCH)
		begin
			myaddr[0]=addr[23:16];
			myaddr[1]=addr[15:8];
			myaddr[2]=addr[7:0];
		end
	else
	begin
		myaddr[0]=myaddr[0];
		myaddr[1]=myaddr[1];
		myaddr[2]=myaddr[2];
	end
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
	begin
		data_out<=8'h11;
		data_valid<=1'b0;
	end
	else if (state==READ_BYTE && wr_ack==1'b1)
	begin
		data_out<=data_recv;
		data_valid<=1'b1;
	end
	else 
	begin
		data_out<=data_out;
		data_valid<=1'b0;
	end
end

endmodule
		