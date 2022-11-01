module control_circuit(
	input [4:0] Opcode,
	output [7:0] control_signal
	/*
	7:BR
	6:JP
	5:ALUinB
	4:ALUop
	3:DMwe
	2:Rwe
	1:Rdst
	0:Rwd
	*/
	);
	
	wire [4:0] not_input;
	not not_array[4:0](not_input, Opcode);
	
	assign control_signal[7] = 1'b0;
	assign control_signal[6] = 1'b0;
	assign control_signal[4] = 1'b0;
	
	//ALUinB
	wire ALUinB1, ALUinB2, ALUinB3;
	and and_gate_1(ALUinB1, not_input[4], not_input[3], Opcode[2], not_input[1], Opcode[0]);
	and and_gate_2(ALUinB2, not_input[4], Opcode[3], not_input[2], not_input[1], not_input[0]);
	and and_gate_3(ALUinB3, not_input[4], not_input[3], Opcode[2], Opcode[1], Opcode[0]);
	or or_gate_1(control_signal[5], ALUinB1, ALUinB2, ALUinB3);
	
	//DWwe
	and and_gate_4(control_signal[3], not_input[4], not_input[3], Opcode[2], Opcode[1], Opcode[0]);
	
	//Rwe
	wire Rwe1, Rwe2, Rwe3;
	and and_gate_5(Rwe1, not_input[4], not_input[3], not_input[2], not_input[1], not_input[0]);
	and and_gate_6(Rwe2, not_input[4], not_input[3], Opcode[2], not_input[1], Opcode[0]);
	and and_gate_7(Rwe3, not_input[4], Opcode[3], not_input[2], not_input[1], not_input[0]);
	or or_gate_2(control_signal[2], Rwe1, Rwe2, Rwe3);
	
	//Rdst
	and and_gate_8(control_signal[1], not_input[4], not_input[3], not_input[2], not_input[1], not_input[0]);
	
	//Rwd
	and and_gate_9(control_signal[0], not_input[4], Opcode[3], not_input[2], not_input[1], not_input[0]);
	
endmodule