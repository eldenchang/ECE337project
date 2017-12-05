// $Id: $
// File name:   tx_sr.sv
// Created:     12/4/2017
// Author:      Qifan Chang
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: output shift register
module tx_sr
(
	input wire clk,
	input wire n_rst,
	input wire [127:0] data_in,
	input wire shift_enable,
	input wire load_enable,
	output wire [31:0] data
);

flexbyte_pts_sr #(.NUM_BYTES_IN(16), .NUM_BYTES_OUT(4)) pts(.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable), .load_enable(load_enable), .data_in(data_in), .data_out(data_out));

endmodule // tx_sr