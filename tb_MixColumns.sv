// $Id: $
// File name:   tb_MixColumns.sv
// Created:     11/28/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench for MixColumns.sv
`timescale 1ns / 10ps
module tb_MixColumns ();

localparam CLOCK_PERIOD = 10;

reg tb_clk;
reg tb_n_rst;
reg tb_enable;
reg [131:0] tb_data_in;
reg [3:0] tb_header_out;
reg [131:0] tb_data_out;

reg [3:0] [3:0] [7:0] tb_array_in;
reg [3:0] [3:0] [7:0] tb_array_out;

integer i, j, k, l;

MixColumns DUT(.clk(tb_clk), .n_rst(tb_n_rst), .enable(tb_enable), .data_in(tb_data_in), .header_out(tb_header_out), .data_out(tb_data_out));

always
begin
	tb_clk = 0;
	#(CLOCK_PERIOD / 2);
	tb_clk = 1;
	#(CLOCK_PERIOD / 2);
end

always @(tb_data_out)
begin
	for (k = 0; k <= 3; k++)
	begin
		for (l = 0; l <= 3; l++)
		begin
			tb_array_out[l][k] = tb_data_out[k * 32 + l * 8 +: 8];
		end
	end
end

initial
begin
	tb_n_rst = 0;
	tb_enable = 0;
	tb_array_in = '0;

	//Sample Data

	tb_data_in = 'h7d4bf5d30000000000000000000000000;

	@(posedge tb_clk);
	
	tb_n_rst = 1;
	tb_enable = 1;
	
	@(posedge tb_clk);
	#(1);

	assert(tb_array_out[3][3] == 'h04)
	else
		$error("Test #1 Failed: tb_array_out[3][3] expected 04, got %h", tb_array_out[3][3]);
	
	assert(tb_array_out[2][3] == 'h66)
	else
		$error("Test #1 Failed: tb_array_out[2][3] expected 66, got %h", tb_array_out[2][3]);
	
	assert(tb_array_out[1][3] == 'h81)
	else
		$error("Test #1 Failed: tb_array_out[1][3] expected 81, got %h", tb_array_out[1][3]);

	assert(tb_array_out[0][3] == 'hE5)
	else
		$error("Test #1 Failed: tb_array_out[0][3] expected e5, got %h", tb_array_out[0][3]);
	
	assert(tb_header_out == 'd7)
	else
		$error("Test #1 Failed: tb_header_out expected 7, got %d", tb_header_out);
end

endmodule