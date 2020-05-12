module di1302(
	input sys_clk,
	input rst_n,
	output reg write_time_ack,
	input write_time_req,
	output reg [7:0] write_data,
	output reg [7:0] write_addr,
	input [7:0] read_data,
	output reg [7:0] read_addr,
	output reg cmd_read,
	output reg cmd_write,
	input cmd_read_ack,
	input cmd_write_ack,
	input [7:0] write_second,
	input [7:0] write_minute,
	input [7:0] write_hour,
	input [7:0] write_date,
	input [7:0] write_month,
	input [7:0] write_year,
	input read_time_req,
	output reg [7:0] read_time_ack,
	output reg [7:0] read_second,
	output reg [7:0] read_minute,
	output reg [7:0] read_hour,
	output reg [7:0] read_date,
	output reg [7:0] read_month,
	output reg [7:0] read_year
);

localparam S_IDLE=4'd0;
localparam S_WR_WP=4'd1;
localparam S_RD_S=4'd2;
localparam S_RD_MIN=4'd3;
localparam S_RD_H=4'd4;
localparam S_RD_D=4'd5;
localparam S_RD_MON=4'd6;
localparam S_RD_Y=4'd7;
localparam S_WR_S=4'd8;
localparam S_WR_MIN=4'd9;
localparam S_WR_H=4'd10;
localparam S_WR_D=4'd11;
localparam S_WR_MON=4'd12;
localparam S_WR_Y=4'd13;
localparam S_ACK=4'd14;

reg [3:0] state;
reg [3:0] next_state;

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
		if ({read_time_req,write_time_req}==2'b10)
			next_state<=S_RD_S;
		else if ({read_time_req,write_time_req}==2'b01)
			next_state<=S_WR_WP;
		else next_state<=S_IDLE;
	S_RD_S:
		if (cmd_read_ack==1'b1) next_state<=S_RD_MIN;
		else next_state<=S_RD_S;
	S_RD_MIN:
		if (cmd_read_ack==1'b1) next_state<=S_RD_H;
		else next_state<=S_RD_MIN;
	S_RD_H:
		if (cmd_read_ack==1'b1) next_state<=S_RD_D;
		else next_state<=S_RD_H;
	S_RD_D:
		if (cmd_read_ack==1'b1) next_state<=S_RD_MON;
		else next_state<=S_RD_MON;
	S_RD_MON:
		if (cmd_read_ack==1'b1) next_state<=S_RD_Y;
		else next_state<=S_RD_Y;
	S_RD_Y:
		if (cmd_read_ack==1'b1) next_state<=S_ACK;
		else next_state<=S_RD_Y;
	S_WR_WP:
		if (cmd_write_ack==1'b1) next_state<=S_WR_S;
		else next_state<=S_WR_WP;
	S_WR_S:
		if (cmd_write_ack==1'b1) next_state<=S_WR_MIN;
		else next_state<=S_WR_S;
	S_WR_MIN:
		if (cmd_write_ack==1'b1) next_state<=S_WR_H;
		else next_state<=S_WR_MIN;
	S_WR_H:
		if (cmd_write_ack==1'b1) next_state<=S_WR_D;
		else next_state<=S_WR_H;
	S_WR_D:
		if (cmd_write_ack==1'b1) next_state<=S_WR_MON;
		else next_state<=S_WR_D;
	S_WR_MON:
		if (cmd_write_ack==1'b1) next_state<=S_WR_Y;
		else next_state<=S_WR_MON;
	S_WR_Y:
		if (cmd_write_ack==1'b1) next_state<=S_ACK;
		else next_state<=S_WR_Y;
	default: next_state<=S_IDLE;
	endcase
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
	begin
		read_time_ack<=1'b0;
		write_time_ack<=1'b0;
	end
	else if (next_state<=S_ACK && {read_time_req,write_time_req}==2'b10)
	begin
		read_time_ack<=1'b1;
		write_time_ack<=1'b0;
	end
	else if (next_state<=S_ACK && {read_time_req,write_time_req}==2'b01)
	begin
		write_time_ack<=1'b1;
		read_time_ack<=1'b0;
	end
	else
	begin
		read_time_ack<=1'b0;
		write_time_ack<=1'b0;
	end
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
	begin
		write_data<=8'd0;
		write_addr<=8'd0;
	end
	else 
	begin
		case (next_state)
		S_WR_WP:
		begin
			write_data<=8'd0;
			write_addr<=8'h8E;
		end
		S_WR_S:
		begin
			write_data<=write_second;
			write_addr<=8'h80;
		end
		S_WR_MIN:
		begin
			write_data<=write_minute;
			write_addr<=8'h82;
		end
		S_WR_H:
		begin
			write_data<=write_hour;
			write_addr<=8'h84;
		end
		S_WR_D:
		begin
			write_data<=write_date;
			write_addr<=8'h86;
		end
		S_WR_MON:
		begin
			write_data<=write_month;
			write_addr<=8'h88;
		end
		S_WR_Y:
		begin
			write_data<=write_year;
			write_addr<=8'h8C;
		end
		default: 
		begin
			write_data<=8'd0;
			write_addr<=8'd0;
		end
		endcase
	end
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
	begin
		read_addr<=8'd0;
		read_second<=8'd0;
		read_minute<=8'd0;
		read_hour<=8'd0;
		read_date<=8'd0;
		read_month<=8'd0;
		read_year<=8'd0;
	end
	else 
	begin
		case (next_state)
		S_RD_S: 
		begin
			read_addr<=8'h81;
		end
		S_RD_MIN: 
		begin
			read_addr<=8'h83;
			read_second<=read_data;
		end
		S_RD_H: 
		begin
			read_addr<=8'h85;
			read_minute<=read_data;
		end
		S_RD_D: 
		begin
			read_addr<=8'h87;
			read_hour<=read_data;
		end
		S_RD_MON: 
		begin
			read_addr<=8'h89;
			read_date<=read_data;
		end
		S_RD_Y: 
		begin
			read_addr<=8'h8D;
			read_month<=read_data;
		end
		S_ACK:
			if (read_time_req==1'b1)
				read_year<=read_data;
		default: read_addr<=8'd0;
		endcase
	end
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
	begin
		cmd_read<=1'b0;
		cmd_write<=1'b0;
	end
	else 
	if (cmd_read_ack==1'b1 || cmd_write_ack==1'b1)
	begin
		cmd_read<=1'b0;
		cmd_write<=1'b0;
	end
	else if ((next_state==S_RD_S || next_state==S_RD_MIN || next_state==S_RD_H || next_state==S_RD_D ||
				next_state==S_RD_MON || next_state==S_RD_Y) && state!=next_state)
	begin
		cmd_read<=1'b1;
		cmd_write<=1'b0;
	end
	else if ((next_state==S_WR_S || next_state==S_WR_MIN || next_state==S_WR_H || next_state==S_WR_D ||
				next_state==S_WR_MON || next_state==S_WR_Y || next_state==S_WR_WP) && state!=next_state)
	begin
		cmd_read<=1'b0;
		cmd_write<=1'b1;
	end
	else
	begin
		cmd_read<=cmd_read;
		cmd_write<=cmd_write;
	end
end

endmodule
