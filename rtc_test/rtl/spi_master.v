module spi_master(
	input sys_clk,
	input rst_n,
	input CE_ctrl,
	input CPOL,
	input CPHA,
	input [3:0] clk_div,
	input wr_req,
	input [7:0] data_in,
	inout data,
	output wire CE,
	output reg clk,
	output reg wr_ack,
	output [7:0] data_recv
);

localparam IDLE=3'd1;
localparam DCLK_IDLE=3'd2;
localparam DCLK_EDGE=3'd3;
localparam ACK=3'd4;
localparam ACK_WAIT=3'd5;
localparam KEEP_CYCLE=3'd6;

reg [3:0] cont;
reg [2:0] contbit,contbitw;
reg [2:0] state;
reg [2:0] next_state;
reg [7:0] data_wreg;
reg [7:0] data_rreg;

wire MISO;
reg MOSI;

assign data_recv=data_rreg;
assign CE=CE_ctrl;
assign data=wr_req? MOSI:1'bz;
assign MISO=data;

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
		if (CE_ctrl==1'b1) next_state<=DCLK_IDLE;
		else next_state<=IDLE;
	DCLK_IDLE:
		if (cont==4'd4) next_state<=DCLK_EDGE;
		else next_state<=DCLK_IDLE;
	DCLK_EDGE:
		if (contbit==3'd7 && clk==1'b1) next_state<=KEEP_CYCLE;
		else next_state<=DCLK_EDGE;
	KEEP_CYCLE:
		if (cont==4'd4) next_state<=ACK;
		else next_state<=KEEP_CYCLE;
	ACK: next_state<=ACK_WAIT;
	ACK_WAIT: 
		if (cont==4'd4) next_state<=IDLE;
		else next_state<=ACK_WAIT;
	default: next_state<=IDLE;
	endcase
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		clk<=1'b1;
	else 
	if (next_state==DCLK_EDGE && state!=DCLK_EDGE)
		clk<=CPOL;
	else
	if (state==DCLK_EDGE && cont==clk_div)
		clk<=~clk;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		cont<=4'd0;
	else if (next_state != state)
		cont<=0;
	else if (state==DCLK_IDLE || state==KEEP_CYCLE || state==ACK_WAIT)
		cont<=cont+4'd1;
	else if (state==DCLK_EDGE)
		if (cont==clk_div)
			cont<=4'd0;
		else cont<=cont+4'd1;
end

always @(negedge clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		contbit<=3'd7;
	else 
		contbit<=contbit+3'd1;
end

always @(posedge clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		contbitw<=3'd0;
	else 
		contbitw<=contbitw+3'd1;
end

always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		data_wreg<=8'd0;
	else 
	if (state==DCLK_IDLE && cont==0)
		if (wr_req==1'b1)
			data_wreg<=data_in;
		else data_wreg<=8'hff;
	
end


always @(posedge sys_clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		wr_ack<=1'b0;
	else if (state==ACK)
		wr_ack<=1'b1;
	else wr_ack<=1'b0;
end

always @(posedge clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		data_rreg<=8'd0;
	else 
		if (state==DCLK_EDGE && wr_req==1'b0)
			data_rreg[contbit]<=MISO;
end

always @(negedge clk or negedge rst_n)
begin
	if (rst_n==1'b0)
		MOSI<=1'b0;
	else
		if (wr_req==1'b1)
		MOSI<=data_wreg[contbitw];
end

endmodule
