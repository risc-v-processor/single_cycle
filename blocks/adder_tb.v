`timescale 1ns / 1ps

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
		val_1 = 0;
		val_2 = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor($time," Val1=%d val2 = %d and out=%d",val_1,val_2,out);
        
        #25;
		val_1=32'd5;
		val_2=32'd9;
		#25
		val_1= 32'h11;
		val_2=32'h22;

	end
      
endmodule

