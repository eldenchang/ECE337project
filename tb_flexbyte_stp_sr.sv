// $Id: $
// File name:   tb_flexbyte_stp_sr.sv
// Created:     11/24/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench for flexbyte_stp_sr.sv.

`timescale 1ns/10ps

module tb_flexbyte_stp_sr();

localparam CLOCK_PERIOD = 10;
localparam INPUT_BYTES1 = 1; //default case
localparam OUTPUT_BYTES = 4;
localparam INPUT_BYTES2 = 2; //mutlibyte case
localparam MSB = 1;

reg tb_clk;
reg tb_n_rst;
reg tb_shift_enable1, tb_shift_enable2, tb_shift_enable3, tb_shift_enable4;
reg [INPUT_BYTES2 * 8 - 1:0] tb_data_in;
reg [OUTPUT_BYTES * 8 - 1:0] tb_data_out1, tb_data_out2, tb_data_out3, tb_data_out4;

//DUT
flexbyte_stp_sr #(MSB, INPUT_BYTES1, OUTPUT_BYTES) DUT(.clk(tb_clk), .n_rst(tb_n_rst), .shift_enable(tb_shift_enable1), .data_in(tb_data_in[INPUT_BYTES1 * 8 - 1:0]), .data_out(tb_data_out1));
flexbyte_stp_sr #(MSB, INPUT_BYTES2, OUTPUT_BYTES) DUT2(.clk(tb_clk), .n_rst(tb_n_rst), .shift_enable(tb_shift_enable2), .data_in(tb_data_in), .data_out(tb_data_out2));
flexbyte_stp_sr #(0, INPUT_BYTES1, OUTPUT_BYTES) DUT3(.clk(tb_clk), .n_rst(tb_n_rst), .shift_enable(tb_shift_enable3), .data_in(tb_data_in), .data_out(tb_data_out3));
flexbyte_stp_sr #(0, INPUT_BYTES2, OUTPUT_BYTES) DUT4(.clk(tb_clk), .n_rst(tb_n_rst), .shift_enable(tb_shift_enable4), .data_in(tb_data_in), .data_out(tb_data_out4));
always
begin
	tb_clk = 1;
	#(CLOCK_PERIOD / 2);
	tb_clk = 0;
	#(CLOCK_PERIOD / 2);
end

initial
begin
	@(posedge tb_clk);
	tb_n_rst = 0;
	tb_data_in = '1;
	tb_shift_enable1 = 0;
	tb_shift_enable2 = 0;
	tb_shift_enable3 = 0;
	tb_shift_enable4 = 0;

	@(posedge tb_clk);
	
	//begin test #1
	tb_shift_enable1 = 1;
	tb_n_rst = 1;

	@(posedge tb_clk);
	
	#(1);
	assert(tb_data_out1 == 32'h000000FF)
	else
	begin
		$error("Initial shift was incorrect, expected 0x000000FF, got %h", tb_data_out1);
	end
	
	@(posedge tb_clk);
	#(1);
	assert(tb_data_out1 == 32'h0000FFFF)
	else
	begin
		$error("Shift was incorrect, expected 0x0000FFFF, got %h", tb_data_out1);
	end
	
	@(posedge tb_clk);
	#(1);
	assert(tb_data_out1 == 32'h00FFFFFF)
	else
	begin
		$error("Shift was incorrect, expected 0x00FFFFFF, got %h", tb_data_out1);
	end
	
	@(posedge tb_clk);
	#(1);
	assert(tb_data_out1 == 32'hFFFFFFFF)
	else
	begin
		$error("Shift was incorrect, expected 0xFFFFFFFF, got %h", tb_data_out1);
	end

	tb_data_in = '0;
	
	@(posedge tb_clk);
	#(1);
	assert(tb_data_out1 == 32'hFFFFFF00)
	else
	begin
		$error("Shift was incorrect, expected 0xFFFFFF00, got %h", tb_data_out1);
	end
	
	@(posedge tb_clk);
	#(1);
	assert(tb_data_out1 == 32'hFFFF0000)
	else
	begin
		$error("Shift was incorrect, expected 0xFFFF0000, got %h", tb_data_out1);
	end
	
	@(posedge tb_clk);
	#(1);
	assert(tb_data_out1 == 32'hFF000000)
	else
	begin
		$error("Shift was incorrect, expected 0xFF000000, got %h", tb_data_out1);
	end
	
	//begin test #2
	tb_shift_enable1 = 0;
	tb_shift_enable2 = 1;
	tb_data_in = 'h0F08;
	@(posedge tb_clk);
	
	#(1);
	assert(tb_data_out2 == 32'h00000F08)
	else
	begin
		$error("Test 2: Shift was incorrect, expected 0x00000f08, got %h", tb_data_out2);
	end
	
	@(posedge tb_clk);
	
	#(1);
	assert(tb_data_out2 == 32'h0F080F08)
	else
	begin
		$error("Test 2: Shift was incorrect, expected 0x00000f08, got %h", tb_data_out2);
	end
	
	tb_data_in = '0;
	
	@(posedge tb_clk);
	
	#(1);
	assert(tb_data_out2 == 32'h0F080000)
	else
	begin
		$error("Test 2: Shift was incorrect, expected 0x0F080000, got %h", tb_data_out2);
	end
	
	@(posedge tb_clk);
	
	#(1);
	assert(tb_data_out2 == 32'h00000000)
	else
	begin
		$error("Test 2: Shift was incorrect, expected 0x00000000, got %h", tb_data_out2);
	end

	//Begin Test #3
	tb_shift_enable2 = 0;
	tb_shift_enable3 = 1;
	tb_data_in = 'h00FF;
	
	@(posedge tb_clk);

	#(1);
	assert(tb_data_out3 == 32'hFF000000)
	else
	begin
		$error("Test 3: Shift was incorrect, expected 0xff000000, got %h", tb_data_out3);
	end
	
	@(posedge tb_clk);

	#(1);
	assert(tb_data_out3 == 32'hFFFF0000)
	else
	begin
		$error("Test 3: Shift was incorrect, expected 0xffff0000, got %h", tb_data_out3);
	end
	
	@(posedge tb_clk);

	#(1);
	assert(tb_data_out3 == 32'hFFFFFF00)
	else
	begin
		$error("Test 3: Shift was incorrect, expected 0xffffff00, got %h", tb_data_out3);
	end
	
	@(posedge tb_clk);

	#(1);
	assert(tb_data_out3 == 32'hFFFFFFFF)
	else
	begin
		$error("Test 3: Shift was incorrect, expected 0xffffffff, got %h", tb_data_out3);
	end
	
	tb_data_in = '0;

	@(posedge tb_clk);

	#(1);
	assert(tb_data_out3 == 32'h00FFFFFF)
	else
	begin
		$error("Test 3: Shift was incorrect, expected 0x00ffffff, got %h", tb_data_out3);
	end
	
	@(posedge tb_clk);

	#(1);
	assert(tb_data_out3 == 32'h0000FFFF)
	else
	begin
		$error("Test 3: Shift was incorrect, expected 0x0000ffff, got %h", tb_data_out3);
	end
	
	@(posedge tb_clk);

	#(1);
	assert(tb_data_out3 == 32'h000000FF)
	else
	begin
		$error("Test 3: Shift was incorrect, expected 0xff0000ff, got %h", tb_data_out3);
	end
	
	@(posedge tb_clk);

	#(1);
	assert(tb_data_out3 == 32'h000000)
	else
	begin
		$error("Test 3: Shift was incorrect, expected 0x00000000, got %h", tb_data_out3);
	end
	
	//Begin Test #4

	tb_shift_enable3 = 0;
	tb_shift_enable4 = 1;
	tb_data_in = 'h0F08;
	
	@(posedge tb_clk);

	#(1);
	assert(tb_data_out4 == 32'h0F080000)
	else
	begin
		$error("Test 4: Shift was incorrect, expected 0x0F080000, got %h", tb_data_out3);
	end
	
	@(posedge tb_clk);

	#(1);
	assert(tb_data_out4 == 32'h0F080F08)
	else
	begin
		$error("Test 4: Shift was incorrect, expected 0x0F080F08, got %h", tb_data_out3);
	end
	
	tb_data_in = '0;
	
	@(posedge tb_clk);

	#(1);
	assert(tb_data_out4 == 32'h00000F08)
	else
	begin
		$error("Test 4: Shift was incorrect, expected 0x00000f08, got %h", tb_data_out3);
	end
	
	@(posedge tb_clk);

	#(1);
	assert(tb_data_out4 == 32'h00000000)
	else
	begin
		$error("Test 4: Shift was incorrect, expected 0x00000000, got %h", tb_data_out3);
	end
	
	
end
endmodule