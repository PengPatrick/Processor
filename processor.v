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
	 
	 

    /* YOUR CODE STARTS HERE */
	 
	 //opcode
	 wire [4:0] opcode;
	 assign opcode = q_imem[31:27];
	 
	 /* control signals */
	 wire [12:0] control_signal;

	 control_circuit my_control_circuit(.Opcode(opcode), .control_signal(control_signal));	
	
	 /* parse insns(q_imem) */

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
	 
	 wire [31:0] operand_B, extended_constant;
	 wire [16:0] constant;
	 assign constant = q_imem[16:0];
	 sign_extension sx_1(extended_constant, constant);
	 
	 	 /* ALU execute part */
	 //operandB

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
	 wire isNotEqual, isLessThan;
	 //wire overflow;
	 alu alu_execute(.data_operandA(data_readRegA), .data_operandB(operand_B), .ctrl_ALUopcode(func_field_in), 
					.ctrl_shiftamt(shamt_in), .data_result(alu_execute_data_result), .overflow(overflow), .isNotEqual(isNotEqual), .isLessThan(isLessThan));
	 
	 
	 // ############## PC & Imem start ################
	 	 
	 wire [31:0] addr_next, addr_curr; 
 
		
	 wire bne, blt, br;
	 // bne signal, only when isNotEqual & bne signal
	 and AND1(bne, control_signal[7], isNotEqual);
	 // isBigerThan signal for blt
	 wire isBigerThan; 
	 and AND_BIGGER(isBigerThan, ~isLessThan, isNotEqual);
	 // blt signal, only when isBiger & blt signal 
	 and AND2(blt, control_signal[10], isBigerThan);
	 // Br Signal ===== for PC = PC + 1 + N
	 or OR2(br, bne, blt);
	 
	 
	 wire jp_jal;
	 or OR_JP_JAL(jp_jal, control_signal[6], control_signal[8]);
	 // for bex, only signal valid & rd != 0
	 wire bex;
	 wire [32:0] dataA;
	 genvar i;
	 generate for(i = 0; i <= 31; i = i + 1)
		begin: labelA
			or ORA(dataA[i+1], dataA[i], data_readRegA[i]);
		end
	 endgenerate

	 and AND5(bex, control_signal[11], dataA[32]);
	 // signal_T ===== for PC = T
	 wire signal_T;
	 or OR_SIGNAL_T(signal_T, jp_jal, bex);
	 
	 // begin the PC update and assign 
	 wire [31:0] addr_curr_tmp, addr_common, addr_temp, addr_br, addr_signal_T, addr_jr;
	 // PC = PC + 1
	 alu PC_COMMON(addr_curr, 32'd1, 5'd0, 5'd0, addr_common, , ,);
	 // PC = PC + 1 (+N)
	 // get the N
	 wire [31:0] addr_br_tmp;
	 assign addr_br_tmp = extended_constant;
	 // PC = PC + 1 + N
	 alu PC_BR(addr_common, addr_br_tmp, 5'd0, 5'd0, addr_br, , ,);
	 // PC = T
	 assign addr_signal_T[26:0] = q_imem[26:0];
	 assign addr_signal_T[31:27] = addr_curr[31:27];
	 // PC = $rd
	 assign addr_jr = data_readRegB; 
	 
	 wire [31:0] addr_tmp1, addr_tmp2;
	 assign addr_tmp1 = br ? addr_br : addr_common;
	 
	 assign addr_next = control_signal[9] ? addr_jr : addr_tmp2;
	 

	 pc PC(.out(addr_curr), .in(addr_next), .clk(clock), .pc_en(1'b1), .clr(reset));	 
	 assign address_imem = addr_curr[11:0];
	 
	 // ############## PC & Imem end   ################
	 
	
	 
	 /*exception part*/
	 wire expr;
	 wire [31:0] status_write;
	 //wire status_en;
	 exception the_exception(opcode, func_field, status_write, status_en);
	 //expr signal
	 and and_gate_expr(expr, overflow, status_en);	 
	 	 
	 
	 
	 /* Regfile output */
	 //ctrl_writeEnable	 
	 assign ctrl_writeEnable = control_signal[2];     // Rwe

	 
	 //ctrl_writeReg
	 // setx write in $30
	 wire [4:0] setx_write;
	 assign setx_write = control_signal[12] ? 5'd30 : reg_d;
	 // jal write in $31
	 wire [4:0] jal_write;
	 assign jal_write = control_signal[8] ? 5'd31 : setx_write;
	 
	 wire [4:0] expr_write;
	 assign expr_write = expr ? 5'd30 : jal_write;
	 assign ctrl_writeReg = expr_write;
	  
	 //ctrl_readRegA
	 assign ctrl_readRegA = control_signal[11] ? 5'd30 : reg_s;    // bex    	 
	 //ctrl_readRegB
	 assign ctrl_readRegB = control_signal[1] ? reg_t : reg_d;  // base on the rdst to implement
	 	 
	 
	 /* dmeme output */
	 //address_dmem
	 assign address_dmem = alu_execute_data_result[11:0];
	 //data
	 assign data = data_readRegB;
	 //wren
	 assign wren = control_signal[3];


	 
	 /* Regfile output */
	 //data_writeReg
	 wire [31:0] data_writeReg_rwd, data_writeReg_ex, data_writeReg_setx;
	 // 2 to 1 Mux for rwd
	 assign data_writeReg_rwd = control_signal[0] ? q_dmem : alu_execute_data_result;
	 // 2 to 1 Mux for exception
	 assign data_writeReg_ex = expr ? status_write : data_writeReg_rwd;
	 // Add new lines here
	 
	 
	 // 2 to 1 Mux for SETX
	 wire [31:0] addr_T, addr_jal;
	 assign addr_T[26:0] = q_imem[26:0];
	 assign addr_T[31:27] = 5'd0;
 
	 assign data_writeReg_setx = control_signal[12] ? addr_T : data_writeReg_ex;
	 // 2 to 1 Mux for jal
	 wire [31:0] addr_imem_tmp;
	 
	 assign addr_imem_tmp = addr_curr;
	 //assign addr_imem_tmp[31:12] = 20'd0;
	 
	 alu ALU_JAL(addr_imem_tmp, 32'd1, 5'd0, 5'd0, addr_jal, , ,);
	 //assign addr_jal[31:12] = 20'd0;
	 assign data_writeReg = control_signal[8] ? addr_jal : data_writeReg_setx;
	 
	 
endmodule
