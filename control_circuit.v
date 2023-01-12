module control_circuit(
	input [4:0] Opcode,
	output [12:0] control_signal
	/*
	12:Setx
	11:Bex
	10:Blt
	9:Jr
	8:Jal
	7:Bne
	6:J
	###################
	5:ALUinB*
	4:ALUop*
	3:DMwe*
	2:Rwe*
	1:Rdst*
	0:Rwd*
	*/
	);
	
	wire [4:0] not_input;
	not not_array[4:0](not_input, Opcode);
	
	assign control_signal[4] = 1'b0;
	
	//ALUinB ====== addi + lw + sw             ***
	wire ALUinB1, ALUinB2, ALUinB3;
	and and_gate_1(ALUinB1, not_input[4], not_input[3], Opcode[2], not_input[1], Opcode[0]);     // addi(00101)
	and and_gate_2(ALUinB2, not_input[4], Opcode[3], not_input[2], not_input[1], not_input[0]);  // lw(01000)
	and and_gate_3(ALUinB3, not_input[4], not_input[3], Opcode[2], Opcode[1], Opcode[0]);        // sw(00111)
	or or_gate_1(control_signal[5], ALUinB1, ALUinB2, ALUinB3);
	
	//DWwe ====== for sw                       ***
	and and_gate_4(control_signal[3], not_input[4], not_input[3], Opcode[2], Opcode[1], Opcode[0]);
	
	//Rwe ====== for ctrl_writeEnable          ***
	wire Rwe1, Rwe2, Rwe3, Rwe4, Rwe5;
	and and_gate_5(Rwe1, not_input[4], not_input[3], not_input[2], not_input[1], not_input[0]);             // all R-type
	and and_gate_6(Rwe2, not_input[4], not_input[3], Opcode[2], not_input[1], Opcode[0]);                   // addi
	and and_gate_7(Rwe3, not_input[4], Opcode[3], not_input[2], not_input[1], not_input[0]);                // lw
	and and_gate_17(Rwe4, not_input[4], not_input[3], not_input[2], Opcode[1], Opcode[0]);                  // jal
	and and_gate_18(Rwe5, Opcode[4], not_input[3], Opcode[2], not_input[1], Opcode[0]);                     // setx
	or or_gate_2(control_signal[2], Rwe1, Rwe2, Rwe3, Rwe4, Rwe5);
	//or or_gate_111(control_signal[2], Rwe1, Rwe2, Rwe3);
	
	//Rdst ====== for R type                   ***
	and and_gate_8(control_signal[1], not_input[4], not_input[3], not_input[2], not_input[1], not_input[0]);
	
	//Rwd  ======  for lw                      ***
	and and_gate_9(control_signal[0], not_input[4], Opcode[3], not_input[2], not_input[1], not_input[0]);

	// ###########################################################################################################################
	
	//J == 6
	and and_gate_10(control_signal[6], not_input[4], not_input[3], not_input[2], not_input[1], Opcode[0]);
	//Bne == 7
	and and_gate_11(control_signal[7], not_input[4], not_input[3], not_input[2], Opcode[1], not_input[0]);
	//Jal == 8
	and and_gate_12(control_signal[8], not_input[4], not_input[3], not_input[2], Opcode[1], Opcode[0]);
	//Jr == 9
	and and_gate_13(control_signal[9], not_input[4], not_input[3], Opcode[2], not_input[1], not_input[0]);
	//Blt == 10
	and and_gate_14(control_signal[10], not_input[4], not_input[3], Opcode[2], Opcode[1], not_input[0]);
	//Bex == 11
	and and_gate_15(control_signal[11], Opcode[4], not_input[3], Opcode[2], Opcode[1], not_input[0]);
	//Setx == 12
	and and_gate_16(control_signal[12], Opcode[4], not_input[3], Opcode[2], not_input[1], Opcode[0]);

	
endmodule

//module control_circuit(
//	input [4:0] Opcode,
//	output [7:0] control_signal
//	/*
//	7:BR
//	6:JP
//	5:ALUinB
//	4:ALUop
//	3:DMwe
//	2:Rwe
//	1:Rdst
//	0:Rwd
//	*/
//	);
//	
//	wire [4:0] not_input;
//	not not_array[4:0](not_input, Opcode);
//	
//	assign control_signal[7] = 1'b0;
//	assign control_signal[6] = 1'b0;
//	assign control_signal[4] = 1'b0;
//	
//	//ALUinB
//	wire ALUinB1, ALUinB2, ALUinB3;
//	and and_gate_1(ALUinB1, not_input[4], not_input[3], Opcode[2], not_input[1], Opcode[0]);
//	and and_gate_2(ALUinB2, not_input[4], Opcode[3], not_input[2], not_input[1], not_input[0]);
//	and and_gate_3(ALUinB3, not_input[4], not_input[3], Opcode[2], Opcode[1], Opcode[0]);
//	or or_gate_1(control_signal[5], ALUinB1, ALUinB2, ALUinB3);
//	
//	//DWwe
//	and and_gate_4(control_signal[3], not_input[4], not_input[3], Opcode[2], Opcode[1], Opcode[0]);
//	
//	//Rwe
//	wire Rwe1, Rwe2, Rwe3;
//	and and_gate_5(Rwe1, not_input[4], not_input[3], not_input[2], not_input[1], not_input[0]);
//	and and_gate_6(Rwe2, not_input[4], not_input[3], Opcode[2], not_input[1], Opcode[0]);
//	and and_gate_7(Rwe3, not_input[4], Opcode[3], not_input[2], not_input[1], not_input[0]);
//	or or_gate_2(control_signal[2], Rwe1, Rwe2, Rwe3);
//	
//	//Rdst
//	and and_gate_8(control_signal[1], not_input[4], not_input[3], not_input[2], not_input[1], not_input[0]);
//	
//	//Rwd
//	and and_gate_9(control_signal[0], not_input[4], Opcode[3], not_input[2], not_input[1], not_input[0]);
//	
//endmodule