module sign_extension(extended_result, immediate);
	
	input [15:0] immediate;
	output [31:0] extended_result;
	
	wire sign;
	assign sign = immediate[15];
	
	genvar i;
	generate
		for(i = 0; i < 16; i = i + 1)begin : copy
			assign extended_result[i] = immediate[i];
		end
	endgenerate

	genvar j;
	generate
		for (j = 31; j >= 16; j = j - 1) begin : sign_ext
			assign extended_result[j] = sign;
		end
	endgenerate

endmodule
