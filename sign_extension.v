module sign_extension(extended_result, immediate);
	
	input [16:0] immediate;
	output [31:0] extended_result;
	
	wire sign_bit;
	integer i;
	
	assign sign_bit = immediate[16];
	
	always @(*) begin
		extended_result[16:0] <= immediate;
	
		for (i = 31; i >= 17; i = i - 1) begin : sign
			extended_result[i] <= sign_bit;
		end
	end

endmodule
