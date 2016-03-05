`timescale 1ns / 1ps

module pc_block_tb;

	// Inputs
	reg rst;
	reg clk;
	reg [31:0] next_addr;

	// Outputs
	wire [31:0] curr_addr;

	// Instantiate the Unit Under Test (UUT)
	pc_block uut (
		.rst(rst), 
		.clk(clk), 
		.next_addr(next_addr), 
		.curr_addr(curr_addr)
	);

	initial begin
		$monitor($time, " reset=%b current address  = %d, next address = %d",rst,curr_addr, next_addr);
		// Initialize Inputs
		rst = 0;
		clk = 0;
		
		// Wait 100 ns for global reset to finish
		#100; 
		
		// Add stimulus here
		next_addr = 32'h1111;
		
		#99 rst = 1;      
		
		#100 rst = 0;
		next_addr = 32'h4444;   
		
		#200;  
		$finish; 
		
	end
	
	always begin
		#50 clk = !clk ;
	end

endmodule
