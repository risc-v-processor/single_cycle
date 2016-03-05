`timescale 1ns / 1ps

//macros
`define REGISTER_WIDTH 32
`define PC_INIT_VAL 32'b0

module pc_block(
	//inputs
	//reset
    input rst,
    //clock
    input clk,
    //next address 
	input [(`REGISTER_WIDTH-1):0] next_addr,
	//current address
	output reg [(`REGISTER_WIDTH-1):0] curr_addr 
);

	//sequential logic
	always @(posedge clk) begin
		if (rst) begin
			curr_addr <= `PC_INIT_VAL;
		end
		
		else begin 
			curr_addr <= next_addr ;
		end
	end	 
	 
endmodule
