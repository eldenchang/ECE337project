// $Id: $
// File name:   AES_nointerface.sv
// Created:     12/4/2017
// Author:      Qifan Chang
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: The AES encryption block without AHB_lite interface
module AES_nointerface(
	input wire clk,
	input wire n_rst,

	input wire start,
	input wire data_received,
	input wire data_type,
	input wire [127:0] data_initial,

	output reg ahb_mode,
	output reg done_chg_key,
	output reg [131:0] data_out
);
wire change_key_done;
wire pipeline_full;
wire data_output;
wire tx_enable;
wire rx_enable;
wire load_key;
wire aes_enable;
wire shift_enable; //from AESctr, signal all four encryption blocks to shift
wire tx_load_enable;
wire current_round;
wire [127:0] data_intial;
wire [127:0] data_raw;
wire [131:0] data_in;
wire [131:0] data_out; //from AESctr, the data output from AESctr
wire [131:0] data_out_sub;
wire [131:0] data_out_shift;
wire [131:0] data_out_mix;
wire [131:0] data_out_addkey;
wire [31:0] data_in_block;
wire [31:0] data_out_block;
wire [127:0] cur_key;
wire [127:0] orig_key;



controller Controller(.clk(clk), .n_rst(n_rst), .start(start), .data_received(data_received), .data_type(data_type), .change_key_done(), .pipeline_full(pipeline_full), .data_output(data_output), .tx_enable(tx_enable), .rx_enable(rx_enable), .load_key(load_key), .aes_enable(aes_enable), .ahb_mode(ahb_mode), .done_chg_key(done_chg_key));
AESctr AESctr(.clk(clk), .n_rst(n_rst), .aes_enabl(aes_enable), .data_initial(data_initial), .data_in(data_out_addkey), .data_out(data_out), .shift_enable(shift_enable), .pipeline_full(pipeline_full), .data_output(data_output));
rx_sr RX_SR(.clk(clk), .n_rst(n_rst), .data_in(data_in_block), .shift_enable(rx_enable), .data_out(data_raw));
tx_sr TX_SR(.clk(clk), .n_rst(n_rst), .data_in(data_out), .shift_enable(rx_enable), .load_enable(tx_load_enable) .data_out(data_out_block));
GenRoundKeys GENKEY(.clk(clk), .n_rst(n_rst), .key_select(load_enable), .rx_key(data_raw), .cur_round(currrent_round), .cur_key(cur_key), .orig_key(orig_key));
Substitute SUBBYTES(.clk(clk), .n_rst(n_rst), .load(shift_enable), .data_in (data_out), .data_out(data_out_sub));
ShiftRows SHIFTROWS(.clk(clk), .n_rst(n_rst), .enable(shift_enable), .data_in (data_out_sub), .data_out(data_out_shift));
MixColumns MIXCOL(.clk(clk), .n_rst(n_rst), .enable(shift_enable), .data_in (data_out_shift), .data_out(data_out_mix));
AddRoundKeys ADDKEYS(.clk(clk), .n_rst(n_rst), .enable(shift_enable), .data_in (data_out_mix), .data_out(data_out_addkey));



endmodule