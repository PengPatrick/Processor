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
    data_readRegB                   // I: Data from port B of regfile
);

	 // What is out of processor: imem, dmem, register
	 // Check the skelenton: there are four parts, register not in the processor
	
	
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
	 
	 
	 output [11:0] 

    /* YOUR CODE STARTS HERE */
	 
	 // Assign four types of clock
	 /*
	 wire pc_clk, imem_clk, dmem_clk, reg_clk;
	 assign imem_clk = clock;
	 assign dmem_clk = clock;
	 
	 clock_divider REG_CLOCK(reg_clk, clock, reset);
	 clock_divider PC_CLOCK(pc_clk, reg_clk, reset);
	 */
	 
	 // Control
	 wire [7:0] ctrl_signal;
	 control_circuit ctrl(q_imem[31:27], ctrl_signal);
	 
	 // PC
	 /*
	 wire [31:0] pc_out, update_pc;
	 wire [31:0] temp;
	 
	 assign temp[0] = 1;
	 pc processor_clock(clock, update_pc, reset, pc_out);
	 assign address_imem = pc_out[11:0];
	 alu ALU_PC(pc_out, temp, 5'b0, 5'b0, update_pc, , ,);
	 */
	 wire[31:0] npc;
	 wire[31:0] npcTemp;
	 assign npcTemp = npc;
	 wire[31:0] npcRes;
	 alu ALU_PC(npcTemp, 32'h1, 5'b0, 5'b0, npcRes, , ,);
	 dffe_mem pc_reg(npc, npcRes, clock, 1'b1, reset);
	 assign address_imem = npc[11:0];
	 
	 // SX
	 wire [31:0] extended_res;
	 sign_extension extend(extended_res, q_imem[16:0]);
	 // ALU
	 wire [31:0] data_operandB, data_result;
	 wire [4:0] ctrl_ALUopcode;
	 wire isNotEqual, isLessThan, overflow;
	 
	 assign ctrl_ALUopcode = q_imem[31:27] ? 5'b0 : q_imem[6:2]; 
	 assign data_operandB = q_imem[31:27] ? extended_res : data_readRegB;
	 alu ALU(data_readRegA, data_operandB, ctrl_ALUopcode, q_imem[11:7], data_result, isNotEqual, isLessThan, overflow);
	 
	 // Dmem
	 assign address_dmem = data_result[11:0];
	 assign wren = ctrl_signal[3];   // DMwe
	 assign data = data_readRegB;
	 
	 // Regfile
	 wire [4:0] rd, rs, rt;
	 assign rd = q_imem[26:22];
	 assign rs = q_imem[21:17];
	 assign rt = q_imem[16:12];
	 
	 assign ctrl_writeEnable = ctrl_signal[2];   // Rwe
	 assign ctrl_writeReg = q_imem[26:22]; //  $rd  q_imem[31:27] ? q_imem[21:17] : q_imem[16:12];
	 assign ctrl_readRegA = q_imem[21:17];  // $rs
	 assign ctrl_readRegB = q_imem[31:27] ? rd : rt;//[21:17] : q_imem[16:12];  // $rt
	 assign data_writeReg = ctrl_signal[0] ? q_dmem : data_result; 
	 
endmodule
