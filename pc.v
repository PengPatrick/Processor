module pc(
	input clk,
	input [31:0] in,
	input pc_en,
	input clr,
	output [31:0] out
	);
	
genvar i;
generate for (i = 0; i <= 31; i = i + 1) 
	begin: label1
		my_dffe my_dffe(out[i], in[i], clk, pc_en, clr);
	end
endgenerate
endmodule
/*
 initial begin
    out <= 32'b0;
 end
 
 always @(posedge clk) begin
	out = clr ? 32'b0 : in;
 end

endmodule
*/	