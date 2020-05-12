module uart_tx
#(
	parameter CLK_FRE = 50,      //clock frequency(Mhz)
	parameter BAUD_RATE = 115200 //serial baud rate
)
(
	input clk,
	input rst_n,
	input tx_data_valid,
	input [7:0] tx_data,
	output reg tx_data_ready,
	output tx_pin
);

reg [31:0] cycle_cnt;
reg [2:0] bit_cnt;
reg tx_reg;
reg [2:0] state;
reg [2:0] next_state;
reg [7:0] tx_data_latch;

localparam CYCLE = CLK_FRE * 1000000 / BAUD_RATE;
localparam S_IDLE=1;
localparam S_START=2;
localparam S_SEND_BIT=3;
localparam S_STOP=4;

assign tx_pin = tx_reg;

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
		state<=S_IDLE;
	else
		state<=next_state;
end

always @(*)
begin 
	case(state)
	S_IDLE:
	begin
		if (tx_data_valid == 1'b1)
			next_state <= S_START;
		else
			next_state <= S_IDLE;
	end
	S_START:
		if (cycle_cnt == CYCLE-1)
			next_state <= S_SEND_BIT;
		else
			next_state <= S_START;
	S_SEND_BIT:
		if (cycle_cnt == CYCLE-1 && bit_cnt==3'd7)
			next_state <= S_STOP;
		else
			next_state <=S_SEND_BIT;
	S_STOP:
		if (cycle_cnt == CYCLE-1)
			next_state <= S_IDLE;
		else 
			next_state <= S_STOP;
	default: next_state <= S_IDLE;
	endcase
end

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
		tx_data_ready <=1'b0;
	else 
	if (state == S_IDLE)
		if (tx_data_valid == 1'b1)
			tx_data_ready <= 1'b0;
		else tx_data_ready<=1'b1;
	else
		if (state == S_STOP && cycle_cnt == CYCLE-1)
			tx_data_ready<=1'b1;
end

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
		tx_data_latch <= 7'd0;
	else
		if (tx_data_valid == 1'b1 && state == S_IDLE)
			tx_data_latch <=tx_data;
end

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
		bit_cnt <= 3'd0;
	else
		if (state == S_SEND_BIT)
			if (cycle_cnt == CYCLE-1)
				if (bit_cnt == 3'd7)
					bit_cnt <= 3'd0;
				else bit_cnt<=bit_cnt+1'd1;
			else
				bit_cnt <= bit_cnt;
		else
			bit_cnt <=0;
end

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
		cycle_cnt <= 31'd0;
	else
		if ((state == S_SEND_BIT && cycle_cnt == CYCLE-1)|| state != next_state)
			cycle_cnt <= 31'd0;
		else 
			cycle_cnt <= cycle_cnt + 31'd1;
end

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
		tx_reg <= 1'b1;
	else
		case(state)
		S_IDLE:
			tx_reg<=1'b1;
		S_START:
			tx_reg<=1'b0;
		S_SEND_BIT:
			tx_reg<=tx_data_latch[bit_cnt];
		S_STOP:
			tx_reg<=1'b1;
		default: tx_reg <=1'b1;
		endcase
end

endmodule
			
		
