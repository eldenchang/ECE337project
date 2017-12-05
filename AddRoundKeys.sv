// $Id: $
// File name:   AddRoundKeys.sv
// Created:     11/25/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Final Step of Encryption Pipeline. Add Round Key to partially
// Encrypted Data.

module AddRoundKeys
(
	input wire clk,
	input wire n_rst,
	input wire enable,
	input wire [131:0] data_in,
	input wire [127:0] key_in,
	output wire [131:0] data_out
);

reg [3:0] header; //packet header
reg [131:0] ff_d, ff_q; //output FF

assign header = data_in[131:128];
assign data_out = ff_q;

always_ff @(posedge clk, negedge n_rst)
begin: OUTPUT_FF
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
begin: OUTPUT_LOGIC
	if (header != 0 && enable == 1)
	begin
		ff_d[127:0] = key_in ^ data_in[127:0];
		ff_d[131:128] = header;
	end
	else
	begin
		ff_d = ff_q;
	end
end
endmodule