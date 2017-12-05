// $Id: $
// File name:   ShiftRows.sv
// Created:     11/21/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Assembles data into a 4x4 array, shifts the rows incrementally.


//IMPORTANT NOTE: MSB IS ASSIGNED TO THE MSB OF THE ARRAY, WITH INDEX 3,3. LAST BYTE IS 0,0.


module ShiftRows
(
	input wire clk,
	input wire n_rst,
	input wire enable,
	input wire [131:0] data_in,
	output wire [131:0] data_out
);

reg [3:0] header; //4-bit header from data_in, will be concatenated later
reg [3:0] [3:0] [7:0] array; //4x4 byte array, with the name array
reg [3:0] [3:0] [7:0] out_array; //4x4 byte array, but contains shifted bytes. intermediary between array and output_d.
reg [2:0] i, j, k, l; //used as a counter for the for loops
reg [131:0] output_d, output_q; //input and output for data_out register

assign header = data_in[131:128];
assign data_out = output_q;

always_comb
begin: CREATE_ARRAY
	for (i = 0; i <= 3; i++)
	begin
		for (j = 0; j <= 3; j++)
		begin
			array[j][i] = data_in[i * 32 + j * 8 +: 8]; //assign data vertically in the array. +: notation is a workaround for a compiler error.
		end
	end
end

always_ff @(posedge clk, negedge n_rst)
begin: OUTPUT_FF
	if (n_rst == '0)
	begin
		output_q <= '0;
	end
	else
	begin
		output_q <= output_d;
	end
end

always_comb
begin: OUTPUT_LOGIC
	if (enable == 1)
	begin
		//shift the array rows

		out_array[3] = array[3];
		out_array[2] = {array[2][0], array[2][3:1]};
		out_array[1] = {array[1][1:0], array[1][3:2]};
		out_array[0] = {array[0][2:0], array[0][3]};

		for (k=0; k <= 3; k++)
		begin
			for (l=0; l <= 3; l++)
			begin
				output_d[120 - k * 32 - l * 8 +: 8] = out_array[3-l][3-k]; //convert array form back into parallel form
			end
		end

		output_d[131:128] = header; //add the header back onto the data
	end
	else
	begin	
		output_d = output_q;
	end
end
endmodule