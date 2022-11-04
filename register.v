module register(d, clk, en, clr, q);

	input [31:0] d;
	input clk, en, clr;
	output [31:0] q;
	
	wire clr;
	
	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin:register
			dffe_ref dffe(q[i], d[i], clk, en, clr);
		end
	endgenerate


endmodule
