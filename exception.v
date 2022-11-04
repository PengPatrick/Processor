module exception(
	input [4:0] opcode,
	input [4:0] func_field,
	output [31:0] status_writeReg,
	output status_en
	);
	
	wire [4:0] not_opcode, not_func_field;
	
	not not_array_1[4:0](not_opcode, opcode);
	not not_array_2[4:0](not_func_field, func_field);
	
	wire [3:0] sel_signal;
	and sel_0(sel_signal[0], not_func_field[4], not_func_field[3], not_func_field[2], not_func_field[1], func_field[0]);
	and sel_1(sel_signal[1], not_func_field[4], not_func_field[3], not_func_field[2], not_func_field[1], not_func_field[0]);
	and sel_2(sel_signal[2], not_opcode[4], not_opcode[3], not_opcode[2], not_opcode[1], not_opcode[0]);
	and sel_3(sel_signal[3], not_opcode[4], not_opcode[3], opcode[2], not_opcode[1], opcode[0]);
	
	wire [31:0] t1, t2, t3, t4;
	assign t1 = sel_signal[0] ? 32'd3 : 32'd0;
	assign t2 = sel_signal[1] ? 32'd1 : t1;
	assign t3 = sel_signal[2] ? t2 : 32'd0;
	assign t4 = sel_signal[3] ? 32'd2 : t3;
	
	assign status_writeReg = t4;
	assign status_en = t4 ? 1'b1 : 1'b0;
	
endmodule