`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:01:46 02/25/2016
// Design Name:   adder
// Module Name:   C:/Users/Nagarathna/ADDER/adder_tb.v
// Project Name:  ADDER
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module adder_tb;

	// Inputs
	reg [31:0] val_1;
	reg [31:0] val_2;

	// Outputs
	wire [31:0] out;

	// Instantiate the Unit Under Test (UUT)
	adder uut (
		.val_1(val_1), 
		.val_2(val_2), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		$monitor($time," Val1=%d val2 = %d and out=%d",val_1,val_2,out);
		val_1 = 0;
		val_2 = 0;


      #25
		val_1=32'd5;
		val_2=32'd9;
		#25
		val_1= 32'h11;
		val_2=32'h22;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

