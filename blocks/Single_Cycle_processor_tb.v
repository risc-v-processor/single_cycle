`timescale 1ns / 1ps

module Single_Cycle_processor_tb;

	// Inputs
	reg rst_t;
	reg clk_t;

	// Outputs
	wire [31:0] mem_map_io_t;

	// Instantiate the Unit Under Test (UUT)
	Single_Cycle_Processor uut (
		.mem_map_io_t(mem_map_io_t), 
		.rst_t(rst_t), 
		.clk_t(clk_t)
	);

	initial begin
		// Initialize Inputs
		rst_t = 0;
		clk_t = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor ($time, "\t clk = %b, rst = rst_t = %b, mem_map_io = %d,\t curr_addr_t = %d,\t \
next_addr_t = %d,\t inst_t = %x,\t pc_mux1_sel_t = %b,\t jalr_t = %b,\t Add_4_Out_t = %d, mem_map_io = %d", 
clk_t, rst_t, mem_map_io_t, uut.curr_addr_t, uut.next_addr_t, uut.inst_t, uut.pc_mux1_sel_t, 
uut.jalr_t, uut.Add_4_Out_t, uut.d_mem_t.mem_map_io);
		
		//reset the design
		rst_t = 1'b1;
		#50;
		rst_t = 1'b0;
		
		//terminate simulation
		#1000;
		$finish;

	end

	always begin
		//generate clock signal
		#20 clk_t = !clk_t;
	end
	     
endmodule

