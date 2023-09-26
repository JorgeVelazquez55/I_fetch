// Quartus II Verilog Template
// Single Port ROM
module Single_Port_ROM
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=32)
(
	enable,
	addr,
	data
);

input 										enable;
input 			[(ADDR_WIDTH-1):0]	addr;
output	reg	[4*DATA_WIDTH-1:0]	data;

//
localparam ROM_Size = 64;

// ROM Variable Declaration
reg [DATA_WIDTH-1:0] rom [ROM_Size-1:0];
wire clk;
assign clk = 1'b0;
wire [DATA_WIDTH-1:0] write_data;
assign write_data = 32'b0;

// Initialize the ROM: put the memory content in the file
// ROM_init.txt, for example. Read this file with $readmemh
// without this file this design will not compile.
// Memory initialization.

initial begin
   $readmemh("../Source Files/Vector_x_Matriz.txt", rom, 0, ROM_Size-1);
end
  
always @(posedge clk) begin
	rom[addr] = write_data;
end

always @* begin
	if (enable) begin
		data[4*DATA_WIDTH-1:3*DATA_WIDTH] = rom[addr[$clog2(ROM_Size):0]+3];
		data[3*DATA_WIDTH-1:2*DATA_WIDTH] = rom[addr[$clog2(ROM_Size):0]+2];
		data[2*DATA_WIDTH-1:  DATA_WIDTH] = rom[addr[$clog2(ROM_Size):0]+1];
		data[  DATA_WIDTH-1:0           ] = rom[addr[$clog2(ROM_Size):0]  ];
	end
	else begin
		data = {(4*DATA_WIDTH-1){1'b0}};
	end
end

endmodule