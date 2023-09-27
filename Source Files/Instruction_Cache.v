//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer:  Edgar Barba & Jorge Velazquez
// Module: I cache
// Description: 
// Module with a ROM definicion function, where we checks
// If the data out is valid, or if rd_en is high is sending instrucctions
// 
//////////////////////////////////////////////////////////////////////////////////

module Instruction_Cache 
#(
	parameter DATA_WIDTH = 32, 
	parameter ADDRESS_WIDTH = 32
)
(
	PC_in,
	Rd_en,
	Abort,
	Dout,
	Dout_valid
);

////////////////////////////////////////////////////////////////////////////////////////////
// Inputs and Outputs definitions
////////////////////////////////////////////////////////////////////////////////////////////
input                     		Rd_en;
input                     		Abort;
input [(ADDRESS_WIDTH-1):0]	PC_in;
output [4*DATA_WIDTH-1:0] 		Dout;
output                    		Dout_valid;

////////////////////////////////////////////////////////////////////////////////////////////
// wires definitions
////////////////////////////////////////////////////////////////////////////////////////////
wire [4*DATA_WIDTH-1:0] ROM_output;
wire [4*DATA_WIDTH-1:0] invalid_output;
////////////////////////////////////////////////////////////////////////////////////////////
// assignments definitions
////////////////////////////////////////////////////////////////////////////////////////////
//Define Data output is valid:
//If data at the output signal is 0
//then data is invalid.
assign Dout_valid     = (ROM_output == {(4*DATA_WIDTH-1){1'b0}}) ? 1'b1 : 1'b0;
//Define an invalid output.
assign invalid_output = {(4*DATA_WIDTH-1){1'b0}};
//Define output signal Data out:
//If input signal Abort is asserted,
//then output data is equal to the invalid output.
//else output data is the data from ROM.
assign Dout           = (Abort == 1'b0) ? ROM_output: invalid_output;

////////////////////////////////////////////////////////////////////////////////////////////
//Instance for a ROM memory with with enable 
////////////////////////////////////////////////////////////////////////////////////////////
Single_Port_ROM
#(
	.DATA_WIDTH(DATA_WIDTH), 
	.ADDR_WIDTH(ADDRESS_WIDTH)) 
Instruction_ROM(
	.enable(Rd_en),
	.addr(PC_in), 
	.data(ROM_output)
);

endmodule
