`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:58:27 02/24/2016
// Design Name:   pc_block
// Module Name:   C:/Users/Nagarathna/PC_BLOCK/pc_block_tb.v
// Project Name:  PC_BLOCK
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pc_block
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

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
	$monitor($time, " reset=%b current address  = %b ",rst,curr_addr );
		// Initialize Inputs
		rst = 0;
		clk = 0;
		next_addr = 32'h1111;
		
		#99 rst = 1;      
		
		#100 rst = 0;
		next_addr = 32'h4444;
		
		// Wait 100 ns for global reset to finish
		#100;  
        
		// Add stimulus here

	end
	always begin
	#50 clk = !clk ;
      end
endmodule

