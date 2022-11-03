/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB,                   // I: Data from port B of regfile
	 
	 //临时增加的测试接口
	 operand_B,
	 overflow,
	 status_en
	 
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
	 
	 //临时增加的接口
	 output [31:0] operand_B;
	 output overflow;
	 output status_en;

    /* YOUR CODE STARTS HERE */
	 
	 /* program counter self-increasing 1 */
	 wire [31:0] pc_address_out, pc_address_in;
	 pc my_pc(.clk(clock), .in(pc_address_in), .clr(reset), .out(pc_address_out));
	 alu alu_pc_plus_4(.data_operandA(pc_address_out), .data_operandB(32'd1), .ctrl_ALUopcode(5'b0), 
					.ctrl_shiftamt(5'b0), .data_result(pc_address_in));
	 /* imeme output */
	 assign address_imem = pc_address_out[11:0];
	 
	 /* parse insns(q_imem) */
	 //opcode
	 wire [4:0] opcode;
	 assign opcode = q_imem[31:27];
	 //rd
	 wire [4:0] reg_d;
	 assign reg_d = q_imem[26:22];
	 //rs
	 wire [4:0] reg_s;
	 assign reg_s = q_imem[21:17];
	 //rt
	 wire [4:0] reg_t;
	 assign reg_t = q_imem[16:12];
	 //shamt
	 wire [4:0] shamt;
	 assign shamt = q_imem[11:7];
	 //func_field
	 wire [4:0] func_field;
	 assign func_field = q_imem[6:2];	 
	 
	 /* control signals */
	 wire [7:0] control_signal;
	 //7:BR 6:JP 5:ALUinB 4:ALUop 3:DMwe 2:Rwe 1:Rdst 0:Rwd
	 control_circuit my_control_circuit(.Opcode(opcode), .control_signal(control_signal));
	 
	 /* Regfile output */
	 //ctrl_writeEnable
	 assign ctrl_writeEnable = control_signal[2];
	 //ctrl_writeReg
	 assign ctrl_writeReg = expr ? 5'b11110 : reg_d;
	 //ctrl_readRegA
	 assign ctrl_readRegA = reg_s;
	 //ctrl_readRegB
	 assign ctrl_readRegB = control_signal[3] ? reg_d : reg_t;
	 //data_writeReg
	 /* ！！！在后面的步骤中补充完成！！！ */
	 
	 /* ALU execute part */
	 //operandB
	 wire [31:0] operand_B, extended_constant;
	 wire [16:0] constant;
	 assign constant = q_imem[16:0];
	 sign_extension sx_1(extended_constant, constant);
	 //assign extended_constant = {{(15){constant[16]}},constant};
	 //assign extended_constant = constant[16] ? {15'b11111_11111_11111,constant} : {15'b0, constant};
	 assign operand_B = control_signal[5] ? extended_constant : data_readRegB;
	 //shamt
	 wire [4:0] shamt_in;
	 assign shamt_in = control_signal[1] ? shamt : 5'b0;
	 //ALUopcode
	 wire [4:0] func_field_in;
	 assign func_field_in = control_signal[1] ? func_field : 5'b0;
	 //calculate and get result/overflow
	 wire [31:0] alu_execute_data_result;
	 //wire overflow;
	 alu alu_execute(.data_operandA(data_readRegA), .data_operandB(operand_B), .ctrl_ALUopcode(func_field_in), 
					.ctrl_shiftamt(shamt_in), .data_result(alu_execute_data_result), .overflow(overflow));
					
	 /*exception part*/
	 wire [31:0] status_write;
	 //wire status_en;
	 exception the_exception(opcode, func_field, status_write, status_en);
	 //expr signal
	 wire expr;
	 and and_gate_expr(expr, overflow, status_en);
					
	 /* dmeme output */
	 //address_dmem
	 assign address_dmem = alu_execute_data_result[11:0];
	 //data
	 assign data = data_readRegB;
	 //wren
	 assign wren = control_signal[3];
	 
	 /* Regfile output */
	 //data_writeReg
	 wire [31:0] data_writeReg_rwd;
	 assign data_writeReg_rwd = control_signal[0] ? q_dmem : alu_execute_data_result;
	 //expr
	 assign data_writeReg = expr ? status_write : data_writeReg_rwd;
	 
endmodule