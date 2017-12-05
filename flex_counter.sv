// $Id: $
// File name:   flex_counter.sv
// Created:     9/14/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Flexible Counter

module flex_counter
#(
	parameter NUM_CNT_BITS = 4
)
(
	input wire clk,
	input wire n_rst,
	input wire clear,
	input wire count_enable,
	input wire [NUM_CNT_BITS - 1: 0] rollover_val,
	output wire [NUM_CNT_BITS - 1: 0] count_out,
	output wire rollover_flag
);

reg [NUM_CNT_BITS - 1:0] ff_count_d;
reg [NUM_CNT_BITS - 1:0] ff_count_q;
reg [NUM_CNT_BITS - 1:0] ff_roll_d;
reg [NUM_CNT_BITS - 1:0] ff_roll_q;

assign count_out = ff_count_d;
assign rollover_flag = ff_roll_d;

always_ff @ (posedge clk, negedge n_rst)
begin: FF_COUNT
	if (n_rst == '0 )
	begin
		ff_count_d <= 0;
	end
	else if (clear == '1 )
	begin
		ff_count_d <= 0;
	end
	else
	begin
		ff_count_d <= ff_count_q;
	end
end

always_ff @ (posedge clk, negedge n_rst)
begin: FF_ROLL
	if (n_rst == '0)
	begin
		ff_roll_d <= '0;
	end
	else
	begin
		ff_roll_d <= ff_roll_q;
	end
end

always_comb
begin: COUNT
	if (clear == '1)
	begin
		ff_count_q <= '0;
	end
	else if ((count_enable == 1) & (rollover_val == ff_count_d))
	begin
		ff_count_q <= 1;
	end
	else if (count_enable == 1)
	begin
		ff_count_q <= ff_count_d + 1;
	end
	else
	begin
		ff_count_q <= ff_count_d;
	end
end

always_comb
begin: ROLL
	if ((((ff_count_d + 1) == rollover_val) & (count_enable == 1)) | ((ff_count_d == rollover_val) & (count_enable == 0)))
	begin
		ff_roll_q <= 1;
	end
	else
	begin
		ff_roll_q <= 0;
	end
end
endmodule