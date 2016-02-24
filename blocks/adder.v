`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:36:51 02/14/2016 
// Design Name: 
// Module Name:    adder 
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
module adder(
    input [`REGISTER_WIDTH-1:0] val_1,
    input [`REGISTER_WIDTH-1:0] val_2,
    output reg [`REGISTER_WIDTH-1:0] out
    );
always @ (*)
out = val_1 + val_2 ;

endmodule
