module decoder_5to32(in, out);

	input [4:0] in;
	output [31:0] out;
	
	wire [4:0] notIn;
	
	genvar i;
	generate 
	
	for(i = 0;i < 5;i = i + 1) begin:notGate
		not(notIn[i], in[i]);
	end
	
	endgenerate
	
	and and0(out[0], notIn[4], notIn[3], notIn[2], notIn[1], notIn[0]);
	and and1(out[1], notIn[4], notIn[3], notIn[2], notIn[1], in[0]);
	and and2(out[2], notIn[4], notIn[3], notIn[2], in[1], notIn[0]);
	and and3(out[3], notIn[4], notIn[3], notIn[2], in[1], in[0]);
	and and4(out[4], notIn[4], notIn[3], in[2], notIn[1], notIn[0]);
	and and5(out[5], notIn[4], notIn[3], in[2], notIn[1], in[0]);
	and and6(out[6], notIn[4], notIn[3], in[2], in[1], notIn[0]);
	and and7(out[7], notIn[4], notIn[3], in[2], in[1], in[0]);
	and and8(out[8], notIn[4], in[3], notIn[2], notIn[1], notIn[0]);
	and and9(out[9], notIn[4], in[3], notIn[2], notIn[1], in[0]);
	and and10(out[10], notIn[4], in[3], notIn[2], in[1], notIn[0]);
	and and11(out[11], notIn[4], in[3], notIn[2], in[1], in[0]);
	and and12(out[12], notIn[4], in[3], in[2], notIn[1], notIn[0]);
	and and13(out[13], notIn[4], in[3], in[2], notIn[1], in[0]);
	and and14(out[14], notIn[4], in[3], in[2], in[1], notIn[0]);
	and and15(out[15], notIn[4], in[3], in[2], in[1], in[0]);
	and and16(out[16], in[4], notIn[3], notIn[2], notIn[1], notIn[0]);
	and and17(out[17], in[4], notIn[3], notIn[2], notIn[1], in[0]);
	and and18(out[18], in[4], notIn[3], notIn[2], in[1], notIn[0]);
	and and19(out[19], in[4], notIn[3], notIn[2], in[1], in[0]);
	and and20(out[20], in[4], notIn[3], in[2], notIn[1], notIn[0]);
	and and21(out[21], in[4], notIn[3], in[2], notIn[1], in[0]);
	and and22(out[22], in[4], notIn[3], in[2], in[1], notIn[0]);
	and and23(out[23], in[4], notIn[3], in[2], in[1], in[0]);
	and and24(out[24], in[4], in[3], notIn[2], notIn[1], notIn[0]);
	and and25(out[25], in[4], in[3], notIn[2], notIn[1], in[0]);
	and and26(out[26], in[4], in[3], notIn[2], in[1], notIn[0]);
	and and27(out[27], in[4], in[3], notIn[2], in[1], in[0]);
	and and28(out[28], in[4], in[3], in[2], notIn[1], notIn[0]);
	and and29(out[29], in[4], in[3], in[2], notIn[1], in[0]);
	and and30(out[30], in[4], in[3], in[2], in[1], notIn[0]);
	and and31(out[31], in[4], in[3], in[2], in[1], in[0]);
	
endmodule
