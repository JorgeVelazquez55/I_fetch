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

input                     		Rd_en;
input                     		Abort;
input [(ADDRESS_WIDTH-1):0]	PC_in;
output [4*DATA_WIDTH-1:0] 		Dout;
output                    		Dout_valid;

wire [4*DATA_WIDTH-1:0] ROM_output;
wire [4*DATA_WIDTH-1:0] invalid_output;

assign Dout_valid     = (ROM_output == {(4*DATA_WIDTH-1){1'b0}}) ? 1'b1 : 1'b0;
assign invalid_output = {(4*DATA_WIDTH-1){1'b0}};
assign Dout           = (Abort == 1'b0) ? ROM_output: invalid_output;


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