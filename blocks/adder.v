`timescale 1ns / 1ps

//macros
`define BUS_WIDTH 32

module adder(
	input [`BUS_WIDTH-1:0] val_1,
	input [`BUS_WIDTH-1:0] val_2,
	output reg [`BUS_WIDTH-1:0] out
);
	always @ (*) begin
		out = val_1 + val_2 ;
	end

endmodule
