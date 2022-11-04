module tristate(in, sel, out);

	input [31:0] in;
	input sel;
	output [31:0] out;
	
	assign out = sel ? in : 32'bz;
	
endmodule
