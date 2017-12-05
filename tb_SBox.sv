// $Id: $
// File name:   tb_SBox.sv
// Created:     11/24/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench for SBox.sv
`timescale 1ns / 10ps
module tb_SBox();

reg [7:0] tb_data_in;
reg [7:0] tb_data_out;

//DUT
SBox DUT(.data_in(tb_data_in), .data_out(tb_data_out));

initial
begin
	tb_data_in = 8'h00;
	#(50);
	assert(tb_data_out == 8'h63)
	begin
		$info("00 output is correct");
	end
	else
	begin
		$error("00 output is incorrect");
	end
	#(50);
	tb_data_in = 8'h11;
	#(50);
	assert(tb_data_out == 8'h82)
	begin
		$info("11 output is correct");
	end
	else
	begin
		$error("11 output is incorrect");
	end
	#(50);
	tb_data_in = 8'h22;
	#(50);
	assert(tb_data_out == 8'h93)
	begin
		$info("22 output is correct");
	end
	else
	begin
		$error("22 output is incorrect");
	end
	#(50);
	tb_data_in = 8'h23;
	#(50);
	assert(tb_data_out == 9'h26)
	begin
		$info("23 output is correct");
	end
	else
	begin
		$error("23 output is incorrect");
	end
	#(50);
end
endmodule