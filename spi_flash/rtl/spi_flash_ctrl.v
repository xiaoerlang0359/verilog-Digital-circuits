module spi_flash_ctrl(
	input sys_clk,
	input rst_n,
	input flash_read,
	input flash_write,
	input flash_bulk_erase,
	input flash_sector_erase,
	output reg flash_read_ack,
	output reg flash_write_ack,
	output reg flash_bulk_erase_ack,
	output reg flash_sector_erase_ack,
	input [23:0] flash_read_addr,
	input [23:0] flash_write_addr,
	input [23:0] flash_sector_addr,
	input [7:0] flash_write_data_in,
	input [7:0] flash_read_size,
	input [7:0] flash_write_size,
	output flash_write_data_req,
	output reg [7:0] flash_read_data_out,
	output reg flash_read_data_valid,
	output reg [7:0] cmd,
	output reg cmd_valid,
	input cmd_ack,
	output reg [23:0] addr,
	output reg [7:0] data_in,
	output reg [7:0] size,
	input [7:0] ack_size,
	input data_req,
	input [7:0] data_out,
	input data_valid
);
	
localparam S_IDLE=4'd1;
localparam S_WREN=4'd2;
localparam S_READ=4'd3;
localparam S_WRITE=4'd4;
localparam S_SE=4'd5;
localparam S_BE=4'd6;
localparam S_CK_STATE=4'd7;
localparam S_ACK=4'd8;
localparam WREN=8'b0000_0110;
localparam WRDI=8'b0000_0100;
localparam RDSR=8'b0000_0101;
localparam READ=8'b0000_0011;
localparam PP=8'b0000_0010;
localparam SE=8'b1101_1000;
localparam BE=8'b1100_0111;

reg [3:0] state;
reg [3:0] next_state;
wire [3:0] func;

assign flash_write_data_req=data_req;
assign func={flash_read,flash_write,flash_bulk_erase,flash_sector_erase};

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		state<=S_IDLE;
	else 
		state<=next_state;
end

always @(*)
begin
	case(state)
	S_IDLE:
	if (flash_read==1'b1 || flash_write==1'b1 || flash_bulk_erase==1'b1 || flash_sector_erase==1'b1)
		next_state<=S_WREN;
	else next_state<=S_IDLE;
	S_WREN:
		if (cmd_ack==1'b1)
			case({flash_read,flash_write,flash_bulk_erase,flash_sector_erase})
			4'b1000:next_state<=S_READ;
			4'b0100:next_state<=S_WRITE;
			4'b0010:next_state<=S_BE;
			4'b0001:next_state<=S_SE;
			default:next_state<=S_IDLE;
			endcase
		else next_state<=S_WREN;
	S_READ:
		if (cmd_ack==1'b1)
			next_state<=S_ACK;
		else next_state<=S_READ;
	S_WRITE:
		if (cmd_ack==1'b1)
			next_state<=S_CK_STATE;
		else next_state<=S_WRITE;
	S_SE:
		if (cmd_ack==1'b1)
			next_state<=S_CK_STATE;
		else next_state<=S_SE;
	S_BE:
		if (cmd_ack==1'b1)
			next_state<=S_CK_STATE;
		else next_state<=S_BE;
	S_CK_STATE:
		if (cmd_ack==1'b1 && data_out[0]==1'b0)
			next_state<=S_ACK;
		else next_state<=S_CK_STATE;
	S_ACK: next_state<=S_IDLE;
	default: next_state<=S_IDLE;
	endcase
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
	begin
		flash_read_ack<=1'b0;
		flash_write_ack<=1'b0;
		flash_bulk_erase_ack<=1'b0;
		flash_sector_erase_ack<=1'b0;
	end
	else 
		if (next_state==S_ACK && state!=next_state)
		begin
			if (flash_read==1'b1)
				flash_read_ack<=1'b1;
			else flash_read_ack<=1'b0;
			if (flash_write==1'b1)
				flash_write_ack<=1'b1;
			else flash_write_ack<=1'b0;
			if (flash_bulk_erase==1'b1)
				flash_bulk_erase_ack<=1'b1;
			else flash_bulk_erase_ack<=1'b0;
			if (flash_sector_erase==1'b1)
				flash_sector_erase_ack<=1'b1;
			else flash_sector_erase_ack<=1'b0;
		end
		else 
		begin
			flash_read_ack<=1'b0;
			flash_write_ack<=1'b0;
			flash_bulk_erase_ack<=1'b0;
			flash_sector_erase_ack<=1'b0;
		end
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		addr<=24'd0;
	else 
	if (state==S_WREN)
		case(func)
			4'b1000:addr<=flash_read_addr;
			4'b0100:addr<=flash_write_addr;
			4'b0010:addr<=24'd0;
			4'b0001:addr<=flash_sector_addr;
			default:addr<=24'd0;
		endcase
	else addr<=addr;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
	begin
		flash_read_data_out<=8'd0;
		flash_read_data_valid<=1'b0;
	end
	else 
		if (state==S_READ && data_valid==1'b1)
		begin
			flash_read_data_out<=data_out;
			flash_read_data_valid<=1'b1;
		end
		else
		begin
			flash_read_data_out<=flash_read_data_out;
			flash_read_data_valid<=0;
		end
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
	begin
		cmd<=8'd0;
		cmd_valid<=1'b0;
	end
	else
		if (next_state==S_WREN)
		begin
			cmd<=WREN;
			cmd_valid<=1'b1;
		end
		else if (next_state==S_READ)
		begin
			cmd<=READ;
			cmd_valid<=1'b1;
		end
		else if (next_state==S_WRITE)
		begin
			cmd<=PP;
			cmd_valid<=1'b1;
		end
		else if (next_state==S_BE)
		begin
			cmd<=BE;
			cmd_valid<=1'b1;
		end
		else if (next_state==S_SE)
		begin
			cmd<=SE;
			cmd_valid<=1'b1;
		end
		else if (next_state==S_CK_STATE)
		begin
			cmd<=RDSR;
			cmd_valid<=1'b1;
		end
		else 
		begin
			cmd<=cmd; cmd_valid<=1'b0;
		end
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		data_in<=8'd0;
	else
		if (state==S_WRITE && flash_write_data_req==1'b1)
			data_in<=flash_write_data_in;
		else data_in<=data_in;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		size<=8'd0;
	else if (next_state<=S_READ)
		size<=flash_read_size;
	else if (next_state<=S_WRITE)
		size<=flash_write_size;
	else size<=size;
end

endmodule
