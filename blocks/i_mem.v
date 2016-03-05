`timescale 1ns / 1ps

//i_mem is a wrapper for mem with a few signals renamed
//some signals of mem are not exposed (mem_size and sz_ex)

//macros
//Bus width
`define BUS_WIDTH 32
//word (32 bits)
`define WORD 2'b10

module i_mem(
	//output
	output [(`BUS_WIDTH - 1) : 0] inst,
	//inputs
	input [(`BUS_WIDTH - 1) : 0] i_mem_address,
	//clock
	input clk,
	//reset
	input rst,
	//write enable
	input i_mem_wr_en,
	//data to be written to memory
	input [(`BUS_WIDTH - 1) : 0] i_mem_wr_data	
);

	//memory size to use (not exposed)
	reg [1:0] mem_size;
	//sign or zero extend (not exposed)
	reg mem_sz_ex;
	
	//create an instance of mem
	mem instruction_memory(
		.data_out(inst),
		.clk(clk),
		.rst(rst),
		.address(i_mem_address),
		.data_in(i_mem_wr_data),
		.wr_en(i_mem_wr_en),
		.mem_size(mem_size),
		.sz_ex(mem_sz_ex)
	);
	
	//Sequential logic
	always @ (posedge clk) begin
		if (rst == 1'b1) begin
			//set the memory access size to the default value
			mem_size <= `WORD;
			//set sign and zero extend to x
			mem_sz_ex <= 1'bx;
		end
	end
	
endmodule
