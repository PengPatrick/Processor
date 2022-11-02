module sign_extension(extended_result, immediate);
	
	input [16:0] immediate;
	output [31:0] extended_result;
	
	wire sign;
	assign sign = immediate[16];
	
	genvar i;
	generate
		for(i = 0; i < 17; i = i + 1)begin : copy
			assign extended_result[i] = immediate[i];
		end
	endgenerate

	genvar j;
	generate
		for (j = 31; j >= 17; j = j - 1) begin : sign_ext
			assign extended_result[j] = sign;
		end
	endgenerate

endmodule
