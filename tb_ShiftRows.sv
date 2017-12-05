// $Id: $
// File name:   tb_ShiftRows.sv
// Created:     11/21/2017
// Author:      Andrew Beatty
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench for ShiftRows.sv
`timescale 1ns / 10ps
module tb_ShiftRows();

localparam CLOCK_CYCLE = 100;

reg tb_clk;
reg tb_n_rst;
reg tb_enable;
reg [131:0] tb_data_in;
reg [131:0] tb_data_out;

//DUT
ShiftRows DUT(.clk(tb_clk), .n_rst(tb_n_rst), .enable(tb_enable), .data_in(tb_data_in), .data_out(tb_data_out));

always
begin
	tb_clk = 0;
	#(CLOCK_CYCLE / 2);
	tb_clk = 1;
	#(CLOCK_CYCLE / 2);
end

initial
begin
	tb_n_rst = 0;
	tb_data_in = 132'h700112233445566778899AABBCCDDEEFF;
	@(posedge tb_clk);
	tb_n_rst = 1;
	tb_enable = 1;
	@(posedge tb_clk);
end
endmodule 