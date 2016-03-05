`timescale 1ns / 1ps

module i_mem_tb;

	// Inputs
	reg [31:0] i_mem_address;
	reg clk;
	reg rst;
	reg i_mem_wr_en;
	reg [31:0] i_mem_wr_data;

	// Outputs
	wire [31:0] inst;

	// Instantiate the Unit Under Test (UUT)
	i_mem uut (
		.inst(inst), 
		.i_mem_address(i_mem_address), 
		.clk(clk), 
		.rst(rst), 
		.i_mem_wr_en(i_mem_wr_en), 
		.i_mem_wr_data(i_mem_wr_data)
	);

	initial begin
		// Initialize Inputs
		i_mem_address = 0;
		clk = 0;
		rst = 0;
		i_mem_wr_en = 0;
		i_mem_wr_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor ($time, " inst = %d, i_mem_address = %d, i_mem_wr_en = %b, i_mem_wr_data = %d", inst, 
					i_mem_address, i_mem_wr_en, i_mem_wr_data);
					
		rst = 1'b1;
		#20;
		rst = 1'b0;
		
		//write data into memory
		#5;
		i_mem_wr_en = 1'b1;
		i_mem_address = 0;
		i_mem_wr_data = 32'h000000FF;
		
		#20;
		i_mem_wr_en = 1'b1;
		i_mem_address = 4;
		i_mem_wr_data = 32'h0000FFFF;
		
		
		#20;
		i_mem_wr_en = 1'b1;
		i_mem_address = 8;
		i_mem_wr_data = 32'h00FFFFFF;
		
		//read back the values
		//read the sign extended byte value at address = 0
		#20;
		i_mem_wr_en = 1'b0;
		i_mem_address = 0;

		
		//read the zero extended half word value at address = 4
		#20;
		i_mem_address = 4;
		
		//end simulation
		#30;
		$finish;
					
	end

	always begin
		//generate clock signal
		#10 clk = ~clk;
	end
	    
endmodule

