// $Id: $
// File name:   AESctr.sv
// Created:     12/1/2017
// Author:      Qifan Chang
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: AES pipeline controller
module AESctr(
	input wire clk,
	input wire n_rst,

	input wire aes_enable, //from controller, to start whole encryption proccess
	input wire [127:0] data_initial, //from preAddKeys, the fresh data first come in
	input wire [131:0] data_in, //from AddRoundKeys, the data from previous round of proccess

	output reg [131:0] data_out, //to Substitute or tx_sr, data either enter next round of proccess or ready to output
	output reg shift_enable, //to Substitute, ShiftRows, MixColumns and AddRoundKeys, tell the pipeline to shift data to next block
	output reg pipeline_full, //to controller, tell controller to stop sending in new data
	output reg data_output //to controller, tell controller a packet from the pipeline is finished with encryption and ready to be output
	);

	int pack_ct = 0; //count the number of packets in the pipeline 
	reg data_ready = 0; // signal if the data is ready to be output
	wire ct; //count the clock cycle to know when to enable pipeline shift

	typedef enum bit [3:0]{IDLE, ENCRYPT, ENCRYPT_IN, ENCRYPT_OUT} stateType;
	stateType state;
	stateType n_state;

	flex_counter #(.NUM_CNT_BITS(4)) counter(.clk(clk), .n_rst(n_rst), .count_enable(clk), .rollover_val(4'd5), .clear(n_rst), .count_out(ct));
	assign shift_enable = (ct == 4);

	always_ff @(posedge clk or negedge n_rst) begin
		if(~n_rst) begin
			state <= IDLE;
		end else begin
			state <= n_state;
		end
	end

	always_comb begin
		n_state = state;
		case(state)
			IDLE: n_state = aes_enable ? ENCRYPT_IN : IDLE;
			//START: n_state = (!data_type && data_received) ? CHK_ADDR : START;
			ENCRYPT_IN: begin
				if(aes_enable) begin
					if (!data_ready) begin
						n_state = pipeline_full ? ENCRYPT : ENCRYPT_IN;
					end
					else begin
						n_state = ENCRYPT_OUT;
					end
				end
				else begin
					n_state = IDLE;
				end
			end
			ENCRYPT: n_state = pipeline_full ? ENCRYPT_OUT : ENCRYPT;
			ENCRYPT_OUT: n_state = ENCRYPT_IN;
		endcase // state
	end

	always_comb begin
		pipeline_full = 0;
		data_output = 0;

		case(state)
			ENCRYPT_IN: begin
				data_out = {data_initial,4'b0000}; //add round counter 4'b0000 to the end of the packet
				pack_ct += 1;
				//load_key = 1;
			end
			ENCRYPT: begin 
				pipeline_full = 1;
				data_out = {data_in[131:4], data_in[3:0]+1};
			end
			ENCRYPT_OUT: begin 
				data_output = 1;
				data_out = {data_in[131:4], data_in[3:0]+1};
				pack_ct -= 1;
			end
		endcase // state
	end
endmodule // controller		