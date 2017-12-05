// $Id: $
// File name:   tb_Substitute.sv
// Created:     11/21/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench for Substitute.sv.
`timescale 1ns/10ps
module tb_Substitute();

localparam CLOCK_PERIOD = 10;

reg tb_clk;
reg tb_n_rst;
reg tb_enable;
reg [131:0] tb_data_in;
reg [131:0] tb_data_out;

//DUT
Substitute DUT(.clk(tb_clk), .n_rst(tb_n_rst), .load(tb_enable), .data_in(tb_data_in), .data_out(tb_data_out));

always
begin: CLOCK_LOGIC
	tb_clk = 1;
	#(CLOCK_PERIOD / 2);
	tb_clk = 0;
	#(CLOCK_PERIOD / 2);
end

initial
begin
	tb_n_rst = 0;
	tb_enable = 0;
	tb_data_in = 'h700112233445566778899AABBCCDDEEFF;
	@(posedge tb_clk);
	tb_enable = 1;
	tb_n_rst = 1;

	//Begin Test #1 (Valid Data)

	@(posedge tb_clk);
	tb_enable = 0;
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	#(1);
	assert(tb_data_out == 'h7638293C31BFC33F5C4EEACEA4BC12816)
		$info("Test #1: Substitution successful. Expected 7638293C31BFC33F5C4EEACEA4BC12816, got %h", tb_data_out);
	else
		$error("Test #1: Substitution failed. Expected 7638293C31BFC33F5C4EEACEA4BC12816, got %h", tb_data_out);

	@(posedge tb_clk); //wait a couple extra cycles, to make sure data is always valid
	@(posedge tb_clk); 
	#(1);
	assert(tb_data_out == 'h7638293C31BFC33F5C4EEACEA4BC12816)
		$info("Test #1: Substitution successful. Expected 7638293C31BFC33F5C4EEACEA4BC12816, got %h", tb_data_out);
	else
		$error("Test #1: Substitution failed. Expected 7638293C31BFC33F5C4EEACEA4BC12816, got %h", tb_data_out);

	tb_data_in[131:128] = '0;
	
	//Begin Test #2 (Invalid Header)
	@(posedge tb_clk);
	tb_enable = 1;
	@(posedge tb_clk);
	tb_enable = 0;
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	#(1);
	assert(tb_data_out == '0)
		$info("Test #2: Invalid data was not encrypted. Expected all 0's, got %h", tb_data_out);
	else
		$error("Test #2: Invalid data was encrypted. Expected all 0's, got %h", tb_data_out);
	

end

endmodule
