//Register File

//macros
//Register file properties
`define REGISTER_COUNT 32
`define REGISTER_WIDTH 32
//5 bits required to address 32 registers
`define REG_INDEX_WIDTH 5

module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
    //Instruction input
    //input [32:0] inst,
    //sign and zero extend module pins
    //output [32:0] sz_ex_val,
    //control unit pins
    //output [14:0] ctrl_op,
    //Control unit
    output [(`REGISTER_WIDTH-1):0] reg_data_1, 
	//bus to send data (operand 2)
	//output [(`REGISTER_WIDTH-1):0] reg_data_2,
	//write enable signal
	input wr_en, 
	//index of register to read from
	input [(`REG_INDEX_WIDTH-1):0] rd_reg_index_1
	//index of register to read from
	//input [(`REG_INDEX_WIDTH-1):0] rd_reg_index_2, 
	//single port to write data to register file
	//index of register to write to
	//input [(`REG_INDEX_WIDTH-1):0] wr_reg_index,
	//data to be written to "wr_reg_index" 
	//input [(`REGISTER_WIDTH-1):0] wr_reg_data  
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

assign led = 8'b0;

//create sign and zero extend module instance
//sz_ex sz_ex_inst (.inst(inst), .sz_ex_val(sz_ex_val));

//control unit instance
/*ctrl ctrl_inst (.inst(inst), 
				.alu_ctrl(ctrl_op[4:0]), 
				.reg_file_wr_en(ctrl_op[5]), 
				.reg_file_wr_back_sel(ctrl_op[7:6]),
				.alu_op2_sel(ctrl_op[8]),
				.d_mem_rd_en(ctrl_op[9]),
				.d_mem_wr_en(ctrl_op[10]),
				.d_mem_size(ctrl_op[12:11]),
				.jal(ctrl_op[13]),
				.jalr(ctrl_op[14]));
*/

//Register file instance
reg_file reg_file_inst (
		.reg_data_1(reg_data_1), 
		//.reg_data_2(reg_data_2), 
		.rst(rst), 
		.wr_en(wr_en), 
		.clk(clk), 
		.rd_reg_index_1(rd_reg_index_1) 
		//.rd_reg_index_2(rd_reg_index_2), 
		//.wr_reg_index(wr_reg_index), 
		//.wr_reg_data(wr_reg_data)
		);
		
endmodule
