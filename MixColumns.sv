// $Id: $
// File name:   MixColumns.sv
// Created:     11/28/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Arranges incoming data into a 4x4 array of bytes. Mixes the 
// columns of this array.




//COMPLETE, AND INITIAL TEST WORKS, BUT I DON'T TRUST RESULTS... NEEDS MORE TESTBENCHES



module MixColumns
(
	input wire clk,
	input wire n_rst,
	input wire enable,
	input wire [131:0] data_in,
	output wire [3:0] header_out,
	output wire [131:0] data_out
);

reg [131:0] ff_d, ff_q; //output FF
reg [3:0] i, j, m, n; //loop variables
genvar k, l;
reg [3:0] [3:0] [7:0] array; //change 3:0 to 0:3?
reg [3:0] [3:0] [7:0] out_array; //output data, still arranged in array

reg [3:0] [3:0] [7:0] mult1, mult2, mult3, mult4; //intermediate steps in matrix multiplication
reg [3:0] [3:0] [7:0] add1, add2;

assign header_out = data_in[131:128];
assign data_out = ff_q;

reg [0:3] [0:3] [7:0] matrix =  
'{
	{8'd2, 8'd1, 8'd1, 8'd3},
	{8'd3, 8'd2, 8'd1, 8'd1},
	{8'd1, 8'd3, 8'd2, 8'd1},
	{8'd1, 8'd1, 8'd3, 8'd2}
};

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
	if (n_rst == 0)
	begin
		ff_q <= '0;
	end
	else
	begin
		ff_q <= ff_d;
	end
end

generate
	for (k = 0; k <= 3; k++)
	begin
		for (l = 0; l <= 3; l++)
		begin
			//matrix multiplication, with finite fields
			ff_mult #(8) MULT1(.mult1(matrix[l][0]), .mult2(array[0][k]), .result(mult1[l][k]));
			ff_mult #(8) MULT2(.mult1(matrix[l][1]), .mult2(array[1][k]), .result(mult2[l][k]));
			ff_mult #(8) MULT3(.mult1(matrix[l][2]), .mult2(array[2][k]), .result(mult3[l][k]));
			ff_mult #(8) MULT4(.mult1(matrix[l][3]), .mult2(array[3][k]), .result(mult4[l][k]));
			
			ff_add #(8) ADD1(.add1(mult1[l][k]), .add2(mult2[l][k]), .result(add1[l][k]));
			ff_add #(8) ADD2(.add1(add1[l][k]), .add2(mult3[l][k]), .result(add2[l][k]));
			ff_add #(8) ADD3(.add1(add2[l][k]), .add2(mult4[l][k]), .result(out_array[l][k]));
			
		end
	end
endgenerate


always_comb
begin: OUTPUT_LOGIC
	if (enable == 1 && header_out != 0)
	begin
		for (m = 0; m <= 3; m++)
		begin
			for (n = 0; n <= 3; n++)
			begin
				ff_d[120 - m * 32 - n * 8 +: 8] = out_array[3-n][3-m]; //convert array form back into parallel form
			end
		end

		ff_d[131:128] = header_out; //add the header back onto the data
	end
	else
	begin	
		ff_d = ff_q;
	end
end

endmodule 