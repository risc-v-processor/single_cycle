`timescale 1ns / 1ps

//d_mem is a wrapper for mem with renaming of signals 
//macros
//Bus width
`define BUS_WIDTH 32

module d_mem(
	//Outputs
	//instruction output
	output [(`BUS_WIDTH-1):0] d_mem_rd_data,
	//Inputs
	//clock
	input clk,
	//reset
	input rst,
	//memory address
	input [(`BUS_WIDTH-1):0] d_mem_address,
	//data to be written to memory
	input [(`BUS_WIDTH-1):0] d_mem_wr_data,
	//write enable signal
	input d_mem_wr_en,
	//memory size
	input [1:0] d_mem_size,
	//sign or zero extend
	//0 -> zero extend
	//1 -> sign extend
	input d_mem_sz_ex
);

	//creata an instance of mem
	mem data_memory (
		.data_out(d_mem_rd_data),
		.clk(clk),
		.rst(rst),
		.address(d_mem_address),
		.data_in(d_mem_wr_data),
		.wr_en(d_mem_wr_en),
		.mem_size(d_mem_size),
		.sz_ex(d_mem_sz_ex)
);

endmodule
