// $Id: $
// File name:   controller.sv
// Created:     11/30/2017
// Author:      Qifan Chang
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: main controller of AES encryption block
module controller(
	input wire clk,
	input wire n_rst,

	input wire start, //from AHB_lite interface, signal for controller to know there are incoming tasks
	input wire data_received, //from AHB_lite interface, for controller to know there is data received by interface
	input wire data_type, // from AHB_lite interface, for controller to know if the incoming data is new key value or video dara
	input wire chg_key_done, // from GenKey, for conroller to know(and also forward to interface) that the key have been stored
	input wire pipeline_full, // from AESctr, for controller to know that the encryption pipeline is full therefore stop fetching new data
	input wire data_output, //from AESctr, for controller to know there is a new packets of data just finished being encrypting

	output reg tx_enable, // to tx_sr, let tx_sr to start shifting out encrypted data
	output reg rx_enable, // to rx_sr, let rx_sr to start shifting in new data
	output reg load_key, //to GenKey and preAddKey, to start loading keys from rx_sr
	output reg aes_enable, //to AESctr, to start the encryption proccess
	output reg ahb_mode, //to AHB_lite interface, tell AHB interface input / output data
	output reg done_chg_key // to AHB_lite interface, to let interface forward the done_chg_key signal to CPU
	);

	typedef enum bit [2:0]{IDLE, START, CHG_KEY, ENCRYP_AND_FETCH, WAIT_ENCRYP, ENCRYP_AND_WRITE, ERROR} stateType;
	stateType state;
	stateType n_state;

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
			IDLE: n_state = start ? START : IDLE;
			//START: n_state = (!data_type && data_received) ? CHK_ADDR : START;
			START: begin
				if(data_type == 0) begin
					n_state = data_received ? CHG_KEY : ERROR;
				end
				else if(data_type == 1) begin
						n_state = data_received ? ENCRYP_AND_FETCH : ERROR;
				end
			end
			CHG_KEY: n_state = chg_key_done ? IDLE : CHG_KEY;
			ENCRYP_AND_FETCH: begin
				if(data_type == 1 && data_received) begin
					if (!data_output) begin
						n_state = pipeline_full ? WAIT_ENCRYP : ENCRYP_AND_FETCH;
					end
					else begin
						n_state = ENCRYP_AND_WRITE;
					end
				end
				else begin
					n_state = ERROR;
				end
			end
			WAIT_ENCRYP: n_state = data_output ? ENCRYP_AND_WRITE : WAIT_ENCRYP;
			ENCRYP_AND_WRITE: n_state = pipeline_full ? ENCRYP_AND_WRITE : ENCRYP_AND_FETCH;
			ERROR: n_state = start ? IDLE :ERROR;
		endcase // state
	end

	always_comb begin
		rx_enable = 0;
		tx_enable = 0;
		load_key = 0;
		aes_enable = 0;
		ahb_mode = 0;
		done_chg_key = 0;

		case(state)
			START: begin
				rx_enable = 1;
				//load_key = 1;
			end
			CHG_KEY: begin 
				rx_enable = 1;
				load_key = 1;
			end
			ENCRYP_AND_FETCH: begin 
				rx_enable = 1;
				aes_enable = 1;
			end
			ENCRYP_AND_WRITE: begin
				tx_enable = 1;
				aes_enable = 1;
			end
			WAIT_ENCRYP: aes_enable = 1;
		endcase // state
	end
endmodule // controller		