`timescale 1ns / 1ps

//single cycle CPU
//macros
//bus width
`define BUS_WIDTH 32
//register file
`define REG1_MSB 19
`define REG1_LSB 15
`define REG2_MSB 24
`define REG2_LSB 20
`define DST_REG_MSB 11
`define DST_REG_LSB 7
`define REG_INDEX_WIDTH 5
//ALU
`define ALU_CTRL_WIDTH 5

module Single_Cycle_Processor(
	//outputs
	//memory mapped I/O
	output [(`BUS_WIDTH-1):0] mem_map_io_t,
	//inputs
	//reset
    input rst_t,
    //clock
    input clk_t
);
 
	//Instantiation of PC_BLOCK
    wire [(`BUS_WIDTH-1):0] next_addr_t ;
    wire [(`BUS_WIDTH-1):0] curr_addr_t ;
	 
    pc_block  pc_bloc_t ( .rst(rst_t), 
						  .clk(clk_t) ,
                          .next_addr(next_addr_t) , 
                          .curr_addr(curr_addr_t) );
	
	//Instantiation of instruction memory
	wire [(`BUS_WIDTH-1):0] inst_t;
	reg i_mem_wr_en_t;
	reg [(`BUS_WIDTH-1):0] i_mem_wr_data_t;
	
	i_mem i_mem_t ( .inst(inst_t),
					.i_mem_address(curr_addr_t),
					.clk(clk_t),
					.rst(rst_t),
					.i_mem_wr_en(i_mem_wr_en_t),
					.i_mem_wr_data(i_mem_wr_data_t) );
              
  
	//Instantiation of adder (PC + 4)
	reg [(`BUS_WIDTH-1):0] val_2_PC_adder = 32'd4;
	wire [(`BUS_WIDTH-1):0] Add_4_Out_t;
	 
	adder adder_t ( .val_1(curr_addr_t) , 
					.val_2(val_2_PC_adder) , 
					.out(Add_4_Out_t) );


	//Instantiation of Control Unit 
	wire [(`ALU_CTRL_WIDTH-1):0] alu_ctrl_t;	
	wire reg_file_wr_en_t;
	wire [1:0] reg_file_wr_back_sel_t;
	wire alu_op2_sel_t;
	wire d_mem_wr_en_t;
	wire d_mem_sz_ex_t;
	wire [1:0] d_mem_size_t;
	wire jal_t;
	wire jalr_t;
	 
	ctrl ctrl_t ( .alu_ctrl(alu_ctrl_t),
				  .reg_file_wr_en(reg_file_wr_en_t),
				  .reg_file_wr_back_sel(reg_file_wr_back_sel_t),
				  .alu_op2_sel(alu_op2_sel_t),
				  .d_mem_wr_en(d_mem_wr_en_t),
				  .d_mem_sz_ex(d_mem_sz_ex_t),
				  .d_mem_size(d_mem_size_t),
				  .jal(jal_t),
				  .jalr(jalr_t), 
				  .inst(inst_t) ); 
						
						
	//Instantiation of register file 
	wire [(`BUS_WIDTH-1):0] reg_data_1_t;
	wire [(`BUS_WIDTH-1):0] reg_data_2_t;
	reg [(`BUS_WIDTH-1):0] wr_reg_data_t;
	wire [(`REG_INDEX_WIDTH-1):0] rd_reg_index_1_t = inst_t[`REG1_MSB :`REG1_LSB] ;
	wire [(`REG_INDEX_WIDTH-1):0] rd_reg_index_2_t = inst_t[`REG2_MSB :`REG2_LSB] ;
	wire [(`REG_INDEX_WIDTH-1):0] wr_reg_index_t = inst_t[`DST_REG_MSB :`DST_REG_LSB] ;
	 
	reg_file reg_file_t ( .reg_data_1(reg_data_1_t), 
						  .reg_data_2(reg_data_2_t),
						  .rst(rst_t), 
						  .clk(clk_t), 
						  .wr_en(reg_file_wr_en_t),
						  .rd_reg_index_1(rd_reg_index_1_t),
                          .rd_reg_index_2(rd_reg_index_2_t), 
                          .wr_reg_index(wr_reg_index_t), 
                          .wr_reg_data(wr_reg_data_t) );	
								 
								 
	//Instantiation of sign extend module
	wire [(`BUS_WIDTH - 1):0] sz_ex_val_t ;
	 
	sz_ex sz_ex_t ( .inst(inst_t), 
					.sz_ex_val(sz_ex_val_t) );
	 
	  
	//Implementation of 2:1 MUX  (second operand to ALU)
	reg [(`BUS_WIDTH-1):0] Operand2_t;
	
	always @ (*) begin 
		case (alu_op2_sel_t)
			1'b0 : Operand2_t = reg_data_2_t;
			1'b1 : Operand2_t = sz_ex_val_t ;
		endcase
	end

	 
	//Implementation OF ALU 
	wire [`BUS_WIDTH : 0] ALU_Out_t;
	wire bcond_t;
	
	Exec Exec_t ( .Operand1(reg_data_1_t), 
				  .Operand2(Operand2_t), 
				  .Out(ALU_Out_t),
				  .Operation(alu_ctrl_t),
				  .bcond(bcond_t) );

    
	//Implementation of simple adder 
	wire [(`BUS_WIDTH-1):0] Add_Out_t;
	adder adder_1_t ( .val_1(curr_addr_t), 
					  .val_2(sz_ex_val_t), 
					  .out(Add_Out_t) );

	
	//Implementation of OR gate 
	wire pc_mux1_sel_t;
	or or1 (pc_mux1_sel_t, jal_t, bcond_t);

	
	//Implemantation of pc_mux_1
	reg [(`BUS_WIDTH-1):0] pc_mux1_Out_t ;
	always @ (*) begin
		case (pc_mux1_sel_t)
			1'b0 : pc_mux1_Out_t = Add_4_Out_t;
			1'b1 : pc_mux1_Out_t = Add_Out_t;
		endcase
	end

		
	//Implementation of pc_mux_2	
	reg [(`BUS_WIDTH-1):0] pc_mux2_Out_t;
	
	always @ (*) begin
		case (jalr_t)
			1'b0 : pc_mux2_Out_t = pc_mux1_Out_t;
			1'b1 : pc_mux2_Out_t = ALU_Out_t ;
		endcase
	end

		
	//connect output of second mux to input of PC block	
	assign next_addr_t = pc_mux2_Out_t;
	
	  
	//Implementation of Data Memory module
	wire [(`BUS_WIDTH-1):0] d_mem_rd_data_t;
	
	d_mem d_mem_t ( .d_mem_rd_data(d_mem_rd_data_t),
					.mem_map_io(mem_map_io_t),
					.clk(clk_t),
					.rst(rst_t),
					.d_mem_address(ALU_Out_t),
					.d_mem_wr_data(reg_data_2_t),
					.d_mem_wr_en(d_mem_wr_en_t),
					.d_mem_size(d_mem_size_t),
					.d_mem_sz_ex(d_mem_sz_ex_t) );


	//Implementation of 2:4 mux (writeback path to register file) 
	always @ (*) begin 
		case(reg_file_wr_back_sel_t)
			2'b00 :	wr_reg_data_t = ALU_Out_t;
			2'b01 : wr_reg_data_t = d_mem_rd_data_t;
			2'b10 : wr_reg_data_t = Add_4_Out_t;
			2'b11 : wr_reg_data_t = Add_Out_t ;
		endcase
	end


	always @ (posedge clk_t) begin
		if (rst_t == 1'b1) begin
			//instruction memory signals
			i_mem_wr_en_t = 1'b0;
			i_mem_wr_data_t = 32'b0;
		end
	end

endmodule
