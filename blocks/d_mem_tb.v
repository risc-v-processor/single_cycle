`timescale 1ns / 1ps

//macros
//Bus width
`define BUS_WIDTH 32
//memory size
//word (32 bits)
`define WORD 2'b10
//half word (16 bits)
`define HALF_WORD 2'b01
//byte (8 bits)
`define BYTE 2'b00

module d_mem_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] d_mem_address;
	reg [31:0] d_mem_wr_data;
	reg d_mem_wr_en;
	reg [1:0] d_mem_size;
	reg d_mem_sz_ex;

	// Outputs
	wire [31:0] d_mem_rd_data;
	wire [31:0] mem_map_io;

	// Instantiate the Unit Under Test (UUT)
	d_mem uut (
		.d_mem_rd_data(d_mem_rd_data), 
		.mem_map_io(mem_map_io), 
		.clk(clk), 
		.rst(rst), 
		.d_mem_address(d_mem_address), 
		.d_mem_wr_data(d_mem_wr_data), 
		.d_mem_wr_en(d_mem_wr_en), 
		.d_mem_size(d_mem_size), 
		.d_mem_sz_ex(d_mem_sz_ex)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		d_mem_address = 0;
		d_mem_wr_data = 0;
		d_mem_wr_en = 0;
		d_mem_size = 0;
		d_mem_sz_ex = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		// Add stimulus here
		$monitor($time, "\t d_mem_rd_data = %d,    d_mem_address = %d,    d_mem_wr_data = %d,    d_mem_wr_en = %b,    d_mem_size = %b, d_mem_sz_ex = %b",
				 d_mem_rd_data, d_mem_address, d_mem_wr_data, d_mem_wr_en, d_mem_size, d_mem_sz_ex);

		//reset
		rst = 1'b1;
		#20
		rst = 1'b0;
		$display ($time);
		
		
		//write data into memory
		#5;
		d_mem_wr_en = 1'b1;
		d_mem_address = 0;
		d_mem_wr_data = 32'h000000FF;
		
		#20;
		d_mem_wr_en = 1'b1;
		d_mem_address = 4;
		d_mem_size = `BYTE;
		d_mem_wr_data = 32'h0000FFFF;
		
		#20;
		d_mem_wr_en = 1'b1;
		d_mem_address = 8;
		d_mem_size = `WORD;
		d_mem_wr_data = 32'h00FFFFFF;
		
		//read back the values
		//read the sign extended byte value at address = 0
		#20;
		d_mem_wr_en = 1'b0;
		d_mem_address = 0;
		d_mem_size = `BYTE;
		d_mem_sz_ex = 1'b1;
		
		//read the zero extended half word value at address = 4
		#20;
		d_mem_address = 4;
		d_mem_size = `HALF_WORD;
		d_mem_sz_ex = 1'b0;
		
		//write a value to memory mapped I/O 
		#20;
		d_mem_address = 256;
		d_mem_size = `WORD;
		d_mem_wr_en = 1'b1;
		d_mem_wr_data = 32'hFFFFFFFF;
		
		//read back the value from memory mapped I/O
		#20;
		d_mem_wr_en = 1'b0;		 
				 
		//terminate simulation
		#30;
		$finish;
		
	end
	
	always begin
		//generate clock signal
		#10 clk = ~clk;
	end
      
endmodule

