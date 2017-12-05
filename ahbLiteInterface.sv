// $Id: $
// File name:   Substitute.sv
// Created:     11/21/2017
// Author:      Cheyenne Martinez
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: AHB Lite Interface

module ahb_lite
(
   input wire fetch,		//Controller sent fetch siganl
   input wire data_ready,	//Controller sent data ready to write
   input wire HCLK,		//Bus clock
   input wire HRESET,		//Reset
   input wire HSEL_SC,		//Slave Select Controller
   input wire HSEL_SS,		//Slave Select SRAM
   input wire [31:0] HADDR,	//Address Bus
   input wire [2:0] HBURST,	//Burst Length
   input wire HMASTLOCK,	//Indicates locked sequence
   input wire [3:0] HPROT,	//Protectin control for bus
   input wire [2:0] HSIZE,	//Size of the transfer: 2-word (64 bits)
   input wire [1:0] HTRANS,	//Transfer Type: IDLE, BUSY, NONSEQUENTIAL, SEQUENTIAL
   input wire [31:0] HWDATA,	//Transfers data from master to slave
   input wire HWRITE,		//Transfer direction
   input wire [31:0] HRDATA, 	//Transfers from slected slave to multiplexor
   output reg HREADYOUT,	//Indicates transfer is finished
   output reg HRESP,		//Transfer response: LOW means OK
   output reg [63:0] data_in	//Data transfered in from controller
   output wire shift_rcv,	//Siganl to shift register to shift in data
   output wire shift_tr,	//Signal to shift register to shift out data 
   output wire address_send	//Signal to controller to read address 
);

   typedef enum logic [3:0] {	RESET, 		// Reset
				READ_M1,	// Read MS 64 bits
				READ_M2,	// Read LS 64 bits
				READ_S1,	// Read MS 64 bits from Decryption block
				READ_S2,	// Read LS 64 bits from Decryption block 
				LOCKED,		// Transfer in process
				READY,		// Ready for data
				WRITE_C1,	// Write MS 64 bits to DB 
				WRITE_C2,	// Write LS 64 bits to DB
				WRITE_S1	// Write MS 64 bits to SRAM
				WRITE_S2} State;// Write LS 64 bits to SRAM

   State c_state;
   State n_state;

   

   always_ff @(posedge HCLK, negedge HRESET) begin
	if(!HRESET)
		n_state <= READY;
	else
		n_state <= c_state;
   end   
   
   always_comb begin // Next State Logic
	case(c_state) 
	READY: begin
		if(HTRANS == 2'b01 && !HWRITE && fetch) //SEQ sent with read signal and fetch from DB
			n_state = READ_M1;
		else if(HTRANS == 2'b01 && !HWRITE && data_ready) //SEQ sent with read signal and data ready sent from DB
			n_state = READ_C1;
		else if(HWRITE && HSEL_SC && !HSEL_SS) //Write signal with slave selected as controller
			n_state = WRITE_C1;
		else if(HWRITE && HSEL_SS && !HSEL_SC) //Write signal with slave selected as SRAM
			n_state = WRITE_S1;
	end
	READ_M1: begin
		n_state = READ_M2;
	end
	READ_M2: begin
		n_state = WRITE_C1;
	end
	READ_S1: begin
		n_state = READ_S2;
	end
	READ_S2: begin
		n_state = WRITE_S1;
	end
	WRITE_S1: begin
		n_state = WRITE_S2;
	end
	WRITE_S2: begin
		n_state = REDAY;
	end
	WRITE_C1: begin
		n_state = WRITE_C2;
	end
	WRITE_C2: begin
		n_state = READY;
	end
   end

   assign shift_tr = (c_state == WRITE_S1) || (c_state == WRITE_S2);
   assign shift_rcv = (c_state == READ_C1) || (c_state == READ_C1);
   assign address_send = (c_state == READ_M1);

endmodule
