// $Id: $
// File name:   tb_ff_mult.sv
// Created:     12/1/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench for Finite Field Multiplication Module.
`timescale 1ns / 10ps
module tb_ff_mult ();

localparam NUM_BITS = 8;

reg [NUM_BITS - 1:0] tb_mult1;
reg [NUM_BITS - 1:0] tb_mult2;
reg [NUM_BITS * 2 - 2:0] tb_result;

ff_mult #(NUM_BITS) MULT(.mult1(tb_mult1), .mult2(tb_mult2), .result(tb_result));

initial
begin
	tb_mult1 = 8'h53;
	tb_mult2 = 8'hCA;
	#(3);
	assert(tb_result == 'h01)
		$info("Test #1 Successful. Expected 01, got %h", tb_result);
	else
		$error("Test #1 Failed. Expected 01, got %h", tb_result);
end

endmodule