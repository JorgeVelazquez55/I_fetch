module I_Fetch
#(
parameter DATA_WIDTH = 32, 
parameter ADDRESS_WIDTH = 32)
(
	clk,
	reset,
	Read_enable,
	jump_branch_valid,
	jump_branch_address,
	empty,
	instruction,
	PC_out
);

input 							clk;
input 							reset;
input 							Read_enable;
input 							jump_branch_valid;
input 	[DATA_WIDTH-1:0]	jump_branch_address;
output							empty;
output	[DATA_WIDTH-1:0]	instruction;
output	[DATA_WIDTH-1:0]	PC_out;

wire 								wp_enable;
wire 								rp_enable;
wire								pc_enable;
wire 								data_invalid;
wire	[2:0]						current_write_pointer;
wire	[2:0]						next_write_pointer;
wire	[4:0]						current_read_pointer;
wire	[4:0]						next_read_pointer;
wire 	[ADDRESS_WIDTH-1:0]	current_PC;
wire 	[ADDRESS_WIDTH-1:0]	next_PC;
wire 	[DATA_WIDTH-1:0]		current_PC_rom;
wire 	[DATA_WIDTH-1:0]		next_PC_rom;
wire 	[4*DATA_WIDTH-1:0]	intruction_block_from_rom;
wire 	[4*DATA_WIDTH-1:0]	current_intruction_block;

reg 	[DATA_WIDTH-1:0]		IFQ_instruction;
reg 	[DATA_WIDTH-1:0]		rom_instruction;

assign next_PC 				= (jump_branch_valid == 1'b1) ? jump_branch_address : current_PC + 1;
assign next_PC_rom			= (jump_branch_valid == 1'b1) ? jump_branch_address : current_PC_rom + 4;
assign next_write_pointer 	= current_write_pointer + 3'b1;
assign next_read_pointer 	= current_read_pointer + 5'b1;
assign wp_enable 				= ((current_read_pointer[3:2] == current_write_pointer[1:0]) && (current_read_pointer[4] != current_write_pointer[2]) && (!jump_branch_valid)) || (data_invalid) ? 1'b0: 1'b1;
assign rp_enable				= Read_enable;
assign pc_enable				= Read_enable;
assign PC_out					= current_PC;
assign empty					= (current_read_pointer[4:2] == current_write_pointer) ? 1'b1: 1'b0;
assign instruction 			= (empty == 1'b1) ? rom_instruction: IFQ_instruction;

Instruction_Cache 
#(
	.DATA_WIDTH(DATA_WIDTH), 
	.ADDRESS_WIDTH(ADDRESS_WIDTH))
I_Cache (
	.PC_in      (current_PC_rom),
	.Rd_en      (Read_enable),
	.Abort      (1'b0),
	.Dout       (intruction_block_from_rom),
	.Dout_valid (data_invalid)
);

Intruction_Fetch_Queue 
#(
	.DATA_WIDTH(DATA_WIDTH))
IFQ_Block (
	.clk(clk),
	.reset(reset),
	.flush(jump_branch_valid),
	.write_enable(wp_enable),
	.write_pointer(current_write_pointer[1:0]),
	.selector(current_read_pointer[3:2]),
	.instruction_block_in(intruction_block_from_rom),
	.instruction_block_out(current_intruction_block)
);

always @* begin
	case (current_read_pointer[1:0])
		2'b11: begin	
			IFQ_instruction = current_intruction_block  [4*DATA_WIDTH-1:3*DATA_WIDTH];
			rom_instruction = intruction_block_from_rom [4*DATA_WIDTH-1:3*DATA_WIDTH];
		end 
		2'b10: begin 
			IFQ_instruction = current_intruction_block  [3*DATA_WIDTH-1:2*DATA_WIDTH];
			rom_instruction = intruction_block_from_rom [3*DATA_WIDTH-1:2*DATA_WIDTH];
		end 
		2'b01: begin 
			IFQ_instruction = current_intruction_block  [2*DATA_WIDTH-1:  DATA_WIDTH];
			rom_instruction = intruction_block_from_rom [2*DATA_WIDTH-1:  DATA_WIDTH];
		end 
		2'b00: begin 
			IFQ_instruction = current_intruction_block  [  DATA_WIDTH-1:0           ];
			rom_instruction = intruction_block_from_rom [  DATA_WIDTH-1:0           ];
		end
	endcase
end

Register
#(
	.DATA_WIDTH(DATA_WIDTH)) PC
(
	.data_in			(next_PC),
	.dafault_data	({(DATA_WIDTH){1'b0}}),
	.reset			(reset),
	.enable			(pc_enable),
	.flush			(1'b0),
	.clk				(clk),
	.data_out		(current_PC)
);

Register
#(
	.DATA_WIDTH(DATA_WIDTH)) PC_rom
(
	.data_in			(next_PC_rom),
	.dafault_data	({(DATA_WIDTH){1'b0}}),
	.reset			(reset),
	.enable			(wp_enable),
	.flush			(1'b0),
	.clk				(clk),
	.data_out		(current_PC_rom)
);

Register
#(
	.DATA_WIDTH(3)) Wp
(
	.data_in			(next_write_pointer),
	.dafault_data	(3'b0),
	.reset			(reset),
	.enable			(wp_enable),
	.flush			(jump_branch_valid),
	.clk				(clk),
	.data_out		(current_write_pointer)
);

Register
#(
	.DATA_WIDTH(5)) Rp
(
	.data_in			(next_read_pointer),
	.dafault_data	({3'b0,next_PC[1:0]}),
	.reset			(reset),
	.enable			(rp_enable),
	.flush			(jump_branch_valid),
	.clk				(clk),
	.data_out		(current_read_pointer)
);

endmodule