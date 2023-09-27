
`timescale 1ns / 1ps
module I_Fetch_tb;

wire empty;
wire [31:0] instruction;
wire [31:0] current_PC;
reg clk;
reg reset;
reg rd_en;
reg jb_en;
reg [31:0] jb_address;

I_Fetch
#(
.DATA_WIDTH(32), 
.ADDRESS_WIDTH(32)) 
UUT(
	.clk(clk),
	.reset(reset),
	.Read_enable(rd_en),
	.jump_branch_valid(jb_en),
	.jump_branch_address(jb_address),
	.empty(empty),
	.instruction(instruction),
	.PC_out(current_PC)
);
initial begin
	jb_address	= 32'b0;
	clk			= 1'b0;
	reset			= 1'b0;
	rd_en			= 1'b1;
	jb_en			= 1'b0;
	#1
	reset			= 1'b1;
	#1
	reset			= 1'b0;
end
//Verificacion de inicializacion de la FIFO
//Llenar la FIFO, esperar que una vez llena 
//Cuando se livera una fila en la FIFO, se cargan
//las siguientes 4 instrucciones
//Ademas re cada cierto tiempo el Rd_en se actva para 
//Verificar los stall o paro de despacho
always begin
	#60
	rd_en			=1'b0;
	#4
	rd_en			=1'b1;
end
//Verificacion de branch, 
//Mandas un entrada valida para activar el branch
//Mandas la direccion de branch a la cual vas a brincar.
//Con esto se validan cosas como el flush de la FIFO
//Que el siguiente cliclo se cargue la instruccion de brinco
//Empty y full con su correcto comportamiento
always begin
	#40
	jb_address	= 32'h0D; 
	jb_en			= 1'b1;
	#2
	jb_en			= 1'b0;	
	#10;
end
always begin
	#54
	jb_address	= 32'h09; 
	jb_en			= 1'b1;
	#2
	jb_en			= 1'b0;	
	#10;
end
always begin
	#1 
	clk = ~clk;
end

endmodule