// $Id: $
// File name:   ff_mult.sv
// Created:     12/1/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Finite Field Multiplication Module.

module ff_mult
#(
	parameter NUM_BITS = 2 //number of bits to multiply together
)
(
	input wire [NUM_BITS - 1 : 0] mult1,
	input wire [NUM_BITS - 1 : 0] mult2,
	output wire [NUM_BITS - 1 : 0] result //4 bit x 4 bit = 7 bit
);

reg [$clog2(NUM_BITS) : 0] i, j; //counter must count through length of mult2, clog2() is base 2 logarithm
//genvar i;
reg [NUM_BITS * 2 - 2 : 0] temp_res = 0; //result that is being created
reg [NUM_BITS * 2 - 2 : 0] res;

always_comb
begin
	for (i = 0; i < NUM_BITS; i++)
	begin
		if (mult2[i] == 1)
		begin
			temp_res = (mult1 << i) ^ temp_res;
		end
		else
		begin
			temp_res = temp_res;
		end
	end

	res = temp_res;
	
	for (j = NUM_BITS * 2 - 1; j >= NUM_BITS; j--) //start from MSB, decrement until desired bit length
	begin
		if (res[j] == 1) //if bit is set, XOR top bits by 0x11B. The leading 1 is to remove the set bit we found
		begin
			res = res ^ ('h11B << (j - NUM_BITS) );
		end
	end
end

assign result = res[NUM_BITS - 1 : 0]; //output the lower desired bits, higher bits are cleared.

endmodule