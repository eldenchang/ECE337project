// $Id: $
// File name:   tb_GenRoundKeys.sv
// Created:     12/3/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench for GenRoundKeys module.
`timescale 1ns /100ps
module tb_GenRoundKeys();

localparam CLOCK_PERIOD = 10;

reg tb_clk;
reg tb_n_rst;
reg tb_key_load;
reg [127:0] tb_rx_key = 'h68656c6c6f3030303030303030303030;
reg [3:0] tb_cur_round;
reg [127:0] tb_cur_key;
reg [127:0] tb_orig_key;

reg [127:0] key_1 = 'h6d616868025158583261686802515858;
reg [127:0] key_2 = 'hbe0b021fbc5a5a478e3b322f8c6a6a77;
reg [127:0] key_3 = 'hb809f77b0453ad3c8a689f130602f564;
reg [127:0] key_4 = 'hc7efb414c3bc192849d4863b4fd6735f;
reg [127:0] key_5 = 'h21607b90e2dc62b8ab08e483e4de97dc;
reg [127:0] key_6 = 'h1ce8fdf9fe349f41553c7bc2b1e2ec1e;
reg [127:0] key_7 = 'hc4268f313a1210706f2e6bb2decc87ac;
reg [127:0] key_8 = 'h0f311e2c35230e5c5a0d65ee84c1e242;
reg [127:0] key_9 = 'h6ca93273598a3c2f038759c18746bb83;
reg [127:0] key_10 = 'h0043de6459c9e24b5a4ebb8add080009;


GenRoundKeys DUT(.clk(tb_clk), .n_rst(tb_n_rst), .key_load(tb_key_load), .rx_key(tb_rx_key), .cur_round(tb_cur_round), .cur_key(tb_cur_key), .orig_key(tb_orig_key));

always
begin: CLOCK_GEN
	tb_clk = 0;
	#(CLOCK_PERIOD / 2);
	tb_clk = 1;
	#(CLOCK_PERIOD / 2);
end

initial
begin
	//initialize data
	tb_n_rst = 0;
	tb_key_load = 0;
	tb_cur_round = 0;
	@(posedge tb_clk);

	//Begin Test #1
	
	//load key
	
	tb_n_rst = 1;
	tb_key_load = 1;
	@(posedge tb_clk);
	
	//generate 1st round
	
	tb_key_load = 0;
	tb_cur_round = 0;
	@(posedge tb_clk);

	tb_cur_round = 1;
	@(posedge tb_clk);
	
	#(1);
	assert(tb_cur_key == key_1)
		$info("Test #1 Key generated successfully: expected %h, got %h", key_1, tb_cur_key);
	else
		$error("Test #1 Key generated failed: expected %h, got %h", key_1, tb_cur_key);
	
	assert(tb_orig_key == tb_rx_key)
		$info("Test #1 Original Key correct: expected %h, got %h", tb_rx_key, tb_orig_key);
	else
		$error("Test #1 Original Key incorrect: expected %h, got %h", tb_rx_key, tb_orig_key);

	tb_cur_round = 2;
	@(posedge tb_clk);
	
	#(1);
	assert(tb_cur_key == key_2)
		$info("Test #1 Key generated successfully: expected %h, got %h", key_2, tb_cur_key);
	else
		$error("Test #1 Key generated failed: expected %h, got %h", key_2, tb_cur_key);
	
	assert(tb_orig_key == tb_rx_key)
		$info("Test #1 Original Key correct: expected %h, got %h", tb_rx_key, tb_orig_key);
	else
		$error("Test #1 Original Key incorrect: expected %h, got %h", tb_rx_key, tb_orig_key);

	tb_cur_round = 3;
	@(posedge tb_clk);

	#(1);
	assert(tb_cur_key == key_3)
		$info("Test #1 Key generated successfully: expected %h, got %h", key_3, tb_cur_key);
	else
		$error("Test #1 Key generated failed: expected %h, got %h", key_3, tb_cur_key);
	
	assert(tb_orig_key == tb_rx_key)
		$info("Test #1 Original Key correct: expected %h, got %h", tb_rx_key, tb_orig_key);
	else
		$error("Test #1 Original Key incorrect: expected %h, got %h", tb_rx_key, tb_orig_key);

	tb_cur_round = 4;
	@(posedge tb_clk);
	#(1);
	assert(tb_cur_key == key_4)
		$info("Test #1 Key generated successfully: expected %h, got %h", key_4, tb_cur_key);
	else
		$error("Test #1 Key generated failed: expected %h got %h", key_4, tb_cur_key);
	
	assert(tb_orig_key == tb_rx_key)
		$info("Test #1 Original Key correct: expected %h, got %h", tb_rx_key, tb_orig_key);
	else
		$error("Test #1 Original Key incorrect: expected %h, got %h", tb_rx_key, tb_orig_key);

	tb_cur_round = 5;
	@(posedge tb_clk);
	#(1);
	assert(tb_cur_key == key_5)
		$info("Test #1 Key generated successfully: expected %h, got %h", key_5, tb_cur_key);
	else
		$error("Test #1 Key generated failed: expected %h, got %h", key_5, tb_cur_key);
	
	assert(tb_orig_key == tb_rx_key)
		$info("Test #1 Original Key correct: expected %h, got %h", tb_rx_key, tb_orig_key);
	else
		$error("Test #1 Original Key incorrect: expected %h, got %h", tb_rx_key, tb_orig_key);

	tb_cur_round = 6;
	@(posedge tb_clk);
	#(1);
	assert(tb_cur_key == key_6)
		$info("Test #1 Key generated successfully: expected %h, got %h", key_6, tb_cur_key);
	else
		$error("Test #1 Key generated failed: expected %h, got %h", key_6, tb_cur_key);
	
	assert(tb_orig_key == tb_rx_key)
		$info("Test #1 Original Key correct: expected %h, got %h", tb_rx_key, tb_orig_key);
	else
		$error("Test #1 Original Key incorrect: expected %h, got %h", tb_rx_key, tb_orig_key);

	tb_cur_round = 7;
	@(posedge tb_clk);
	@(posedge tb_clk);
	#(1);
	assert(tb_cur_key == key_7)
		$info("Test #1 Key generated successfully: expected %h, got %h", key_7, tb_cur_key);
	else
		$error("Test #1 Key generated failed: expected %h, got %h", key_7, tb_cur_key);
	
	assert(tb_orig_key == tb_rx_key)
		$info("Test #1 Original Key correct: expected %h, got %h", tb_rx_key, tb_orig_key);
	else
		$error("Test #1 Original Key incorrect: expected %h, got %h", tb_rx_key, tb_orig_key);

	tb_cur_round = 8;
	@(posedge tb_clk);
	@(posedge tb_clk);
	#(1);
	assert(tb_cur_key == key_8)
		$info("Test #1 Key generated successfully: expected %h, got %h", key_8, tb_cur_key);
	else
		$error("Test #1 Key generated failed: expected %h, got %h", key_8, tb_cur_key);
	
	assert(tb_orig_key == tb_rx_key)
		$info("Test #1 Original Key correct: expected %h, got %h", tb_rx_key, tb_orig_key);
	else
		$error("Test #1 Original Key incorrect: expected %h, got %h", tb_rx_key, tb_orig_key);

	tb_cur_round = 9;
	@(posedge tb_clk);
	@(posedge tb_clk);
	#(1);
	assert(tb_cur_key == key_9)
		$info("Test #1 Key generated successfully: expected %h, got %h", key_9, tb_cur_key);
	else
		$error("Test #1 Key generated failed: expected %h, got %h", key_9, tb_cur_key);
	
	assert(tb_orig_key == tb_rx_key)
		$info("Test #1 Original Key correct: expected %h, got %h", tb_rx_key, tb_orig_key);
	else
		$error("Test #1 Original Key incorrect: expected %h, got %h", tb_rx_key, tb_orig_key);

	tb_cur_round = 10;
	@(posedge tb_clk);
	@(posedge tb_clk);
	#(1);
	assert(tb_cur_key == key_10)
		$info("Test #1 Key generated successfully: expected %h, got %h", key_10, tb_cur_key);
	else
		$error("Test #1 Key generated failed: expected %h, got %h", key_10, tb_cur_key);
	
	assert(tb_orig_key == tb_rx_key)
		$info("Test #1 Original Key correct: expected %h, got %h", tb_rx_key, tb_orig_key);
	else
		$error("Test #1 Original Key incorrect: expected %h, got %h", tb_rx_key, tb_orig_key);

	tb_cur_round = 1;
	@(posedge tb_clk);

	@(posedge tb_clk);
	@(posedge tb_clk);
	
	#(1);
	assert(tb_cur_key == key_1)
		$info("Test #1 Key generated successfully: expected %h, got %h", key_1, tb_cur_key);
	else
		$error("Test #1 Key generated failed: expected %h, got %h",key_1, tb_cur_key);
	
	assert(tb_orig_key == tb_rx_key)
		$info("Test #1 Original Key correct: expected %h, got %h", tb_rx_key, tb_orig_key);
	else
		$error("Test #1 Original Key incorrect: expected %h, got %h", tb_rx_key, tb_orig_key);
end
endmodule