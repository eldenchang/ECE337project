// $Id: $
// File name:   flexbyte_stp_sr.sv
// Created:     11/24/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Flexible Serial to Parallel Multibyte Shift Register.


module flexbyte_stp_sr
#(
	parameter MSB = 1, //boolean, is MSB coming first?
	parameter NUM_BYTES_IN = 1, //number of bytes being passed to shift register
	parameter NUM_BYTES_OUT = 2
)
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire [NUM_BYTES_IN * 8 - 1:0] data_in,
	output wire [NUM_BYTES_OUT * 8 - 1:0] data_out
);

reg [NUM_BYTES_OUT * 8 - 1:0] ff_d, ff_q;
assign data_out = ff_q;

initial
begin
	assert(NUM_BYTES_OUT > NUM_BYTES_IN)
	else
	begin
		$fatal("Output bytes must be larger than input bytes.");
	end
	
	assert( (NUM_BYTES_OUT % NUM_BYTES_IN) == 0) //likely not intended, throw a warning
	else
	begin
		$warning("Output bytes are not a multiple of input bytes. Was this intentional?");
	end
end

always_ff @(posedge clk, negedge n_rst)
begin: FF_OUTPUT
	if (n_rst == '0)
	begin
		ff_q <= '0;
	end
	else
	begin
		ff_q <= ff_d;
	end
end

always_comb
begin: OUTPUT_LOGIC
	if (shift_enable == 1)
	begin
		if (MSB == 0)
		begin
			ff_d = ff_q >> (8 * NUM_BYTES_IN);
			ff_d[NUM_BYTES_OUT * 8 - 1 -: NUM_BYTES_IN * 8] = data_in;
		end
		else
		begin
			ff_d = ff_q << (8 * NUM_BYTES_IN);
			ff_d[NUM_BYTES_IN * 8 - 1:0] = data_in;
		end
	end
	else
		ff_d = ff_q;
end
endmodule