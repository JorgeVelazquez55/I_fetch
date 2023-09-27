//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer:  Edgar Barba & Jorge Velazquez
// Module: Register
// Description: 
// Generic Register Definition.
// Data will be storage every clk rising edge if en is asserted.
// rst assertion will clear stored data.
//////////////////////////////////////////////////////////////////////////////////
module Register #(parameter DATA_WIDTH=32)(
data_in,
dafault_data,
reset,
enable,
flush,
clk,
data_out
);

////////////////////////////////////////////////////////////////////////////////////////////
// Inputs and Outputs definitions
////////////////////////////////////////////////////////////////////////////////////////////
input      [(DATA_WIDTH-1):0] data_in;
input      [(DATA_WIDTH-1):0] dafault_data;
input                         reset;
input                         enable;
input                         flush;
input                         clk;
output reg [(DATA_WIDTH-1):0] data_out;

////////////////////////////////////////////////////////////////////////////////////////////
// Always procedural block
////////////////////////////////////////////////////////////////////////////////////////////
always @ (posedge clk, posedge reset)
begin
  if(reset == 1'b1)begin
    data_out <= {(DATA_WIDTH){1'b0}};
  end
  else if (flush == 1'b1)begin
	 data_out <= dafault_data;
	end
  else if (enable == 1'b1) begin
    data_out <= data_in;
  end
  else 
	 data_out <= data_out;
end

initial begin
	data_out = {(DATA_WIDTH){1'b0}};
end
endmodule
