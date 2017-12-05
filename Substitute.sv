// $Id: $
// File name:   Substitute.sv
// Created:     11/21/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Substitution step of the encryption pipeline.

module Substitute
(
	input wire clk,
	input wire n_rst,
	input wire load, //this is the "enable" signal
	input wire [131:0] data_in,
	output wire [131:0] data_out
);

reg [99:0] input_d, input_q; //loaded data FF
reg [3:0] header; //packet header
reg [7:0] input1, input2, input3, input4; //input into SBox x4
reg [7:0] output1, output2, output3, output4; //output of SBox x4
reg [31:0] sr_input; //input of flexbyte_stp_sr
reg [127:0] sr_output; //output of flexbyte_stp_sr, before header is added
reg rollover_flag;

assign header = input_q[99:96];
assign data_out = (header == 0) ? '0 : {header, sr_output};

flex_counter #(3) Counter(.clk(clk), .n_rst(n_rst), .count_enable(load | ~rollover_flag), .rollover_val(3'd4), .rollover_flag(rollover_flag));
SBox SBox1(.data_in(input1), .data_out(output1));
SBox SBox2(.data_in(input2), .data_out(output2));
SBox SBox3(.data_in(input3), .data_out(output3));
SBox SBox4(.data_in(input4), .data_out(output4));
flexbyte_stp_sr #(1, 4, 16) SR(.clk(clk), .n_rst(n_rst), .shift_enable(load | ~rollover_flag), .data_in(sr_input), .data_out(sr_output));

always_ff @(posedge clk, negedge n_rst)
begin: LOAD_FF
	if (n_rst == 0)
	begin
		input_q <= '0;
	end
	else
	begin
		if (load == 1)
		begin
			input_q[95:0] <= data_in[95:0];
			input_q[99:96] <= data_in[131:128];
		end
		else
		begin
			input_q <= input_d;
		end
	end
end

always_comb
begin: LOAD_FF_D
	if (~rollover_flag)
	begin
		input_d[99:96] = input_q[99:96];
		input_d[95:0] = input_q[95:0] << 32;
	end
	else
	begin
		input_d = input_q;
	end
end

always_comb
begin: SBOX_INPUT
	if (load)
	begin
		input1 = data_in[127:120];
		input2 = data_in[119:112];
		input3 = data_in[111:104];
		input4 = data_in[103:96];
	end
	else
	begin
		input1 = input_q[95:88];
		input2 = input_q[87:80];
		input3 = input_q[79:72];
		input4 = input_q[71:64];
	end
end

always_comb
begin: SR_CONCAT
	sr_input = {output1, output2, output3, output4};
end

endmodule