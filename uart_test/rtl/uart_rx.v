module uart_rx
#(
	parameter CLK_FRE = 50,      //clock frequency(Mhz)
	parameter BAUD_RATE = 115200 //serial baud rate
)
(
	input clk,
	input rst_n,
	output reg rx_data_valid,
	output reg [7:0] rx_data,
	input rx_data_ready,
	input rx_pin
);
reg [31:0] cycle_cnt;
reg [2:0] bit_cnt;
reg [2:0] state;
reg [2:0] next_state;
reg [7:0] rx_bit;
reg rxd0;
reg rxd1;
wire rx_negedge;

localparam CYCLE = CLK_FRE * 1000000 / BAUD_RATE;
localparam S_IDLE=1;
localparam S_START=2;
localparam S_REC_DATA=3;
localparam S_STOP =4;
localparam S_DATA=5;

assign rx_negedge = rxd1 & (~rxd0);

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
	begin
		rxd1 <= 1'b1;
		rxd0 <= 1'b1;
	end
	else
	begin
		rxd0 <= rx_pin;
		rxd1 <= rxd0;
	end
end

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
		if (rx_negedge == 1'b1)
			next_state<=S_START;
		else next_state<=S_IDLE;
	S_START:
		if (cycle_cnt == CYCLE-1)
			next_state<=S_REC_DATA;
		else next_state<=S_START;
	S_REC_DATA:
		if (cycle_cnt == CYCLE-1 && bit_cnt == 3'd7)
			next_state<=S_STOP;
		else next_state<=S_REC_DATA;
	S_STOP:
		if (cycle_cnt == (CYCLE-1)/2)
			next_state<=S_DATA;
		else next_state<=S_STOP;
	S_DATA:
		if (rx_data_ready == 1'b1)
			next_state<=S_IDLE;
		else next_state<=S_DATA;
	default:next_state<=S_IDLE;
	endcase
end

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
		rx_data_valid <=1'b0;
	else
		if (state == S_STOP && next_state!=state)
			rx_data_valid <= 1'b1;
		else
			if (state == S_DATA && rx_data_ready == 1'b1)
				rx_data_valid <=1'b0;
end

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
		rx_data <=8'd0;
	else
		if (state == S_STOP && next_state!=state)
			rx_data <= rx_bit;
end

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
		bit_cnt <= 3'd0;
	else
		if (state == S_REC_DATA)
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
		if ((state == S_REC_DATA && cycle_cnt == CYCLE-1)|| state != next_state)
			cycle_cnt <= 31'd0;
		else 
			cycle_cnt <= cycle_cnt + 31'd1;
end

always @(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
		rx_bit <= 8'd0;
	else
		if (state == S_REC_DATA && cycle_cnt == (CYCLE-1)/2)
			rx_bit[bit_cnt] <= rx_pin;
		else rx_bit<=rx_bit;
end

endmodule
