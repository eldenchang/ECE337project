// $Id: $
// File name:   tb_AddRoundKeys.sv
// Created:     11/25/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench for AddRoundKeys.sv
`timescale 1ns / 10ps
module tb_AddRoundKeys();

localparam CLOCK_PERIOD = 10;

reg tb_clk;
reg tb_n_rst;
reg tb_enable;
reg [127:0] tb_key_in;
reg [131:0] tb_data_in;
reg [131:0] tb_data_out;

//DUT
AddRoundKeys DUT(.clk(tb_clk), .n_rst(tb_n_rst), .enable(tb_enable), .data_in(tb_data_in), .key_in(tb_key_in), .data_out(tb_data_out));

always
begin: CLOCK_GEN
	tb_clk = 1;
	#(CLOCK_PERIOD / 2);
	tb_clk = 0;
	#(CLOCK_PERIOD / 2);
end

initial
begin
	tb_n_rst = 0;
	tb_enable = 0;
	tb_key_in = 'hFFEEDDCCBBAA99887766554433221100;
	tb_data_in = 'h700112233445566778899AABBCCDDEEFF;
	@(posedge tb_clk);
	
	tb_n_rst = 1;
	tb_enable = 1;
	
	//Begin Test #1
	
	@(posedge tb_clk);
	#(1);
	assert(tb_data_out == 'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
		$info("Test #1 Successful: expected 'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, got %h", tb_data_out);
	else
		$error("Test #1 Failed: expected 'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, got %h", tb_data_out);
	
end
endmodule