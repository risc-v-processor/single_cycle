`timescale 1ns / 1ps

//d_mem is a wrapper for mem with renaming of signals 
//macros
//Bus width
`define BUS_WIDTH 32

module d_mem(
	//Outputs
	//instruction output
	output reg [(`BUS_WIDTH-1):0] d_mem_rd_data,
	//memory mapped I/O
	output reg [(`BUS_WIDTH-1):0] mem_map_io,
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
	//memory write enable
	reg mem_wr_en;
	//memory mapped I/O write enable
	reg mem_map_io_wr_en;
	//data read from either "mem" instance or "memory mapped I/O"
	reg [(`BUS_WIDTH-1):0] mem_rd_data;

	//combinational logic
	always @ (*) begin
		if (d_mem_address == 256) begin
			//read from memory mapped I/O
			d_mem_rd_data = mem_map_io;
			
			//write to memory mapped I/O
			if (d_mem_wr_en == 1'b1) begin
				mem_wr_en = 1'b0;
				mem_map_io_wr_en = 1'b1;
			end
			
			else begin
				mem_wr_en = 1'b1;
				mem_map_io_wr_en = 1'b0;
			end	
		end
		
		//read from data memory
		else begin
			d_mem_rd_data = mem_rd_data; 
		end		
	end
	
	//sequential logic
	always @ (posedge clk) begin
		if (rst == 1'b1) begin
			mem_map_io <= 32'b0;
		end
		
		else if (mem_map_io_wr_en == 1'b1) begin
			mem_map_io <= d_mem_wr_data;
		end
	end
	
	//creata an instance of mem
	mem data_memory (
		.data_out(mem_rd_data),
		.clk(clk),
		.rst(rst),
		.address(d_mem_address),
		.data_in(d_mem_wr_data),
		.wr_en(mem_wr_en),
		.mem_size(d_mem_size),
		.sz_ex(d_mem_sz_ex)
);

endmodule
