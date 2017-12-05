// $Id: $
// File name:   flexbyte_pts_sr.sv
// Created:     11/28/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Flexible Parallel to Serial Multibyte Shift Register.


//NOTE: NOT TESTED YET.

module flexbyte_pts_sr
#(
	parameter MSB = 1, //boolean, is MSB shifted out first?
	parameter NUM_BYTES_IN = 2, //number of bytes passed to shift register
	parameter NUM_BYTES_OUT = 1 //number of bytes shifted out of shift register
)
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire load_enable,
	input wire [NUM_BYTES_IN * 8 - 1:0] data_in,
	output wire [NUM_BYTES_OUT * 8 - 1:0] data_out
);

initial
begin
	assert(NUM_BYTES_IN > NUM_BYTES_OUT) //input size must be larger than output
	else
		$fatal("Input bytes must be larger than output bytes.");
	
	assert(NUM_BYTES_IN % NUM_BYTES_OUT == 0) //this shouldn't break SR, but is likely a mistake by the user
	else
		$warning("Number of output bytes is not a multiple of input bytes. Is this a mistake?");
	
end

reg [NUM_BYTES_IN * 8 - 1:0] ff_d, ff_q;
reg [NUM_BYTES_OUT * 8 -1:0] shift_out;

always_ff @(posedge clk, negedge n_rst)
begin: LOAD_FF
	if (n_rst == 0)
	begin
		ff_q <= '0;
	end
	else
	begin
		ff_q <= ff_d;
	end
end

always_comb
begin: NEXT_STATE_LOGIC
	if (load_enable == 1)
	begin
		ff_d = data_in;
	end
	else if (shift_enable == 1)
	begin
		if (MSB == 1)
		begin
			ff_d = {ff_q[NUM_BYTES_IN * 8 - NUM_BYTES_OUT * 8 - 1 : 0], '0}; //grab all remaining bits and shift them to the left, fill empty space with 0's
		end
		else
		begin
			ff_d = {'0, ff_q[NUM_BYTES_IN * 8 - 1 : NUM_BYTES_OUT * 8]}; //grab all remaining bits and shift them right, fill empty space with 0's
		end
	end
	else
	begin
		ff_d = ff_q;
	end
end

always_comb
begin: OUTPUT_LOGIC
	if (MSB == 1)
	begin
		shift_out = ff_q[NUM_BYTES_IN * 8 - 1 : NUM_BYTES_IN * 8 - NUM_BYTES_OUT * 8]; //shift out most significant chunk of data
	end
	else
	begin
		shift_out = ff_q[NUM_BYTES_OUT * 8 - 1 : 0]; //shift out least significant chunk of data
	end
end
endmodule