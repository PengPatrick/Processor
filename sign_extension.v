module sign_extension(extended_result, immediate);
	
<<<<<<< HEAD
	input [15:0] immediate;
	output [31:0] extended_result;
	
	wire sign;
	assign sign = immediate[15];
	
	genvar i;
	generate
		for(i = 0; i < 16; i = i + 1)begin : copy
=======
	input [16:0] immediate;
	output [31:0] extended_result;
	
	wire sign;
	assign sign = immediate[16];
	
	genvar i;
	generate
		for(i = 0; i < 17; i = i + 1)begin : copy
>>>>>>> cffac3166ebc375e41d1368628e102358a1a1fb4
			assign extended_result[i] = immediate[i];
		end
	endgenerate

	genvar j;
	generate
<<<<<<< HEAD
		for (j = 31; j >= 16; j = j - 1) begin : sign_ext
=======
		for (j = 31; j >= 17; j = j - 1) begin : sign_ext
>>>>>>> cffac3166ebc375e41d1368628e102358a1a1fb4
			assign extended_result[j] = sign;
		end
	endgenerate

endmodule
