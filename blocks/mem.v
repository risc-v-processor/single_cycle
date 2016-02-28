`timescale 1ns / 1ps

//macros
//Bus width
`define BUS_WIDTH 32
//Byte addressable memory
//Memory vector size = Total size/8
//(2Kb memory)
`define MEM_VECTOR_SIZE 256
//memory size
//word (32 bits)
`define WORD 2'b10
//half word (16 bits)
`define HALF_WORD 2'b01
//byte (8 bits)
`define BYTE 2'b00

module mem(
	//Outputs
	//instruction output
	output reg [(`BUS_WIDTH-1):0] data_out,
	//Inputs
	//clock
	input clk,
	//reset
	input rst,
	//memory address
	input [(`BUS_WIDTH-1):0] address,
	//data to be written to memory
	input [(`BUS_WIDTH-1):0] data_in,
	//write enable signal
	input wr_en,
	//memory size
	input [1:0] mem_size,
	//sign or zero extend
	//0 -> zero extend
	//1 -> sign extend
	input sz_ex
);

	//memory array (LUT configured as memory)
	reg [7:0] mem [(`MEM_VECTOR_SIZE - 1):0];
	
	//combinational logic
	//read from memory
	always @ (*) begin
		if (address < `MEM_VECTOR_SIZE) begin
			if(sz_ex == 1'b1) begin
				//perform sign extend
				case (mem_size)
					`WORD: begin
						data_out = {{mem[address+3]}, {mem[address+2]}, {mem[address+1]}, {mem[address]}};
					end
					
					`HALF_WORD: begin
						data_out = {{(16){mem[address+1][7]}}, {mem[address+1]}, {mem[address]}}; 
					end
					
					`BYTE: begin
						data_out = {{(24){mem[address][7]}}, {mem[address]}};
					end
						
					default: begin
						data_out = {(`BUS_WIDTH-1){1'bx}};
					end
								
				endcase
			end
			
			else begin
				//perform zero extend
				case (mem_size) 
					`WORD: begin
						data_out = {{mem[address+3]}, {mem[address+2]}, {mem[address+1]}, {mem[address]}};
					end
					
					`HALF_WORD: begin
						data_out = {{(16){1'b0}}, {mem[address+1]}, {mem[address]}}; 
					end
					
					`BYTE: begin
						data_out = {{(24){1'b0}}, {mem[address]}};
					end
						
					default: begin
						data_out = {(`BUS_WIDTH-1){1'bx}};
					end
								
				endcase					
			end
		end
		
		else begin
			data_out = {(`BUS_WIDTH-1){1'bx}};
		end
		
	end
	
	//count integer
	integer i;
	
	//sequential logic
	//initializing and writing to memory
	always @ (posedge clk) begin
		//initialize memory
		if (rst == 1'b1) begin
			//zero out the memory
			for(i=0; i<`MEM_VECTOR_SIZE; i = i+1) begin
				mem[i] <= {(8){1'b0}};
			end
		end
		
		//write data to memory
		else if (wr_en == 1'b1) begin
			mem[address] = data_in[7:0];
			mem[address + 1] = data_in[15:8];
			mem[address + 2] = data_in[23:16];
			mem[address + 3] = data_in[31:24];
		end
	end

endmodule
