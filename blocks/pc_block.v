`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:30:08 02/14/2016 
// Design Name: 
// Module Name:    pc_block 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define REGISTER_WIDTH 32
`define PC_INIT_VAL 32'b0
module pc_block(
    input rst,
    input clk  ,
	 input [`REGISTER_WIDTH-1:0] next_addr ,
	 output reg [`REGISTER_WIDTH-1:0] curr_addr 
    );
initial
  curr_addr = `PC_INIT_VAL ;
always @(posedge clk) begin
 if(rst)
     curr_addr = `PC_INIT_VAL ;
	else 
     curr_addr = next_addr ;
  end	  
endmodule
