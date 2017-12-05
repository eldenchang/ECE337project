// $Id: $
// File name:   ff_add.sv
// Created:     12/1/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Finite Field Addition Module.

module ff_add
#(
	parameter NUM_BITS = 1 //number of bits to add together
)
(
	input wire [NUM_BITS - 1:0] add1,
	input wire [NUM_BITS - 1:0] add2,
	output wire [NUM_BITS - 1:0] result
);

assign result = add1 ^ add2;

endmodule